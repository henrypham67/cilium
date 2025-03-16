variable "github_username" {
  type        = string
  description = "GitHub username"
}

variable "github_token" {
  type        = string
  description = "GitHub token"
  sensitive   = true
}

variable "github_repository" {
  type        = string
  description = "GitHub repository"
}

variable "aws_access_key_id" {
  type        = string
  sensitive   = true
  description = "AWS access key ID"
}


variable "aws_secret_access_key" {
  type        = string
  sensitive   = true
  description = "AWS secret access key"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-west-2"
}

variable "cluster_version" {
  type        = string
  description = "EKS cluster version"
  default     = "1.32"
}
