resource "flux_bootstrap_git" "this" {
  depends_on = [module.eks]

  embedded_manifests = true
  path               = "clusters/my-cluster"
}