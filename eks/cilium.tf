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