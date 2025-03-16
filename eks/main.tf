data "aws_availability_zones" "available" {
  # Exclude local zones
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  name = "cilium-test"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  cilium_patch = {
    spec = {
      template = {
        spec = {
          nodeSelector = {
            "io.cilium/aws-node-enabled" = "true"
          }
        }
      }
    }
  }

  taints_cilium = {
    cilium = {
      key    = "node.cilium.io/agent-not-ready"
      value  = "true"
      effect = "NO_EXECUTE"
    }
  }

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }
}

################################################################################
# VPC
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  intra_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 52)]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = local.tags
}

################################################################################
# EKS
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.33.1"

  cluster_name                             = local.name
  cluster_version                          = var.cluster_version
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  self_managed_node_groups = {
    on_demand_nodes = {
      ami_type      = "AL2_x86_64"
      instance_type = "t3.medium"

      min_size = 2
      max_size = 5
      # This value is ignored after the initial creation
      # https://github.com/bryantbiggs/eks-desired-size-hack
      desired_size = 2
      # capacity_type = "ON_DEMAND"
    }
  }

  tags = local.tags
}

data "aws_eks_cluster_auth" "this" {
  name = local.name
}

module "kubeconfig" {
  depends_on = [module.eks]
  source     = "github.com/littlejo/terraform-kubernetes-kubeconfig?ref=no-experiment"

  current_context = "eks"
  clusters = [{
    name                       = "kubernetes"
    server                     = module.eks.cluster_endpoint
    certificate_authority_data = module.eks.cluster_certificate_authority_data
  }]
  contexts = [{
    name         = "eks",
    cluster_name = "kubernetes",
    user         = "eks",
  }]
  users = [{
    name  = "eks",
    token = data.aws_eks_cluster_auth.this.token
    }
  ]
}

resource "terraform_data" "delete_kube_proxy" {
  depends_on = [module.kubeconfig]
  provisioner "local-exec" {
    command = <<-EOT
      kubectl -n kube-system delete ds kube-proxy || true
      kubectl -n kube-system delete cm kube-proxy || true
      kubectl -n kube-system patch daemonset aws-node --type='strategic' -p='${jsonencode(local.cilium_patch)}'
    EOT
    environment = {
      KUBECONFIG = "./kubeconfig"
    }
  }
}

module "cilium" {
  depends_on = [module.eks, terraform_data.delete_kube_proxy]
  source     = "terraform-module/release/helm"
  version    = "2.8.2"

  namespace  = "kube-system"
  repository = "https://helm.cilium.io/"

  app = {
    name             = "cilium"
    version          = "1.17.1"
    chart            = "cilium"
    create_namespace = true
    force_update     = true
    wait             = true
    recreate_pods    = false
    deploy           = 1
  }

  values = [
    templatefile("${path.module}/values/cilium.yaml", {
      CLUSTER_ENDPOINT = replace(module.eks.cluster_endpoint, "https://", "")
    })
  ]
}

resource "kubernetes_secret" "aws_credentials" {
  metadata {
    name = "aws-credentials"
  }
  data = {
    "aws_access_key_id"     = var.aws_access_key_id
    "aws_secret_access_key" = var.aws_secret_access_key
  }
}
