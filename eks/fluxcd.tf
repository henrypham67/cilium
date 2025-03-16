resource "flux_bootstrap_git" "this" {
  # depends_on = [github_repository.this]

  embedded_manifests = true
  path               = "clusters/my-cluster"
}