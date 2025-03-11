variable "github_username" {
  type        = string
  description = "GitHub username"
}

variable "github_token" {
  type        = string
  description = "GitHub token"
  sensitive   = true
}
