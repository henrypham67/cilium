data "aws_availability_zones" "available" {
  # Exclude local zones
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  name   = "cilium-test"
  region = "us-west-2"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

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

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.33.1"

  cluster_name                             = local.name
  cluster_version                          = "1.32"
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  # EKS Addons
  cluster_addons = {
    coredns = {
      most_recent = true
    }

    eks-pod-identity-agent = {
      most_recent = true
    }
  }

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

module "cilium" {
  depends_on = [ module.eks ]
  source  = "terraform-module/release/helm"
  version = "2.8.2"

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

  set = [
    {
      name  = "eni.enabled"
      value = "true"
    },

    {
      name  = "ipam.mode"
      value = "eni"
    },

    {
      name  = "egressMasqueradeInterfaces"
      value = "eth+"
    },

    {
      name  = "routingMode"
      value = "native"
    }
  ]
}
module "fluxcd" {
  depends_on = [ module.cilium ]
  source  = "terraform-module/release/helm"
  version = "2.8.2"

  namespace  = "flux-system"
  repository = "oci://ghcr.io/fluxcd-community/charts"

  app = {
    name             = "flux2"
    version          = "2.15.0"
    chart            = "flux2"
    create_namespace = true
    force_update     = true
    wait             = true
    recreate_pods    = false
    deploy           = 1
  }

  values = [file("${path.cwd}/templates/flux2_values.yml")]

  set = []
}

resource "kubernetes_secret" "github_auth" {
  depends_on = [ module.fluxcd ]
  metadata {
    name      = "flux-system"
    namespace = "flux-system"
  }

  data = {
    username = var.github_username
    password = var.github_token
  }
}

resource "kubernetes_manifest" "flux_gitrepository" {
  manifest = {
    apiVersion = "source.toolkit.fluxcd.io/v1"
    kind       = "GitRepository"
    metadata = {
      name      = "my-app"
      namespace = "flux-system"
    }
    spec = {
      interval = "5m"
      url      = "https://github.com/your-org/your-repo.git"
      ref = {
        branch = "main"
      }
      secretRef = {
        name = "flux-system"
      }
      ignore = "**/*"   # Ignore everything
      include = ["fluxcd-apps/**"]  # Sync only this folder
    }
  }
}