# Variables
SHELL := /bin/bash
.DEFAULT_GOAL := help

# Terraform variables
TF_VAR_FILE ?= terraform.tfvars
WORKSPACE ?= default

.PHONY: help
help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: init
init: ## Initialize Terraform
	terraform init

.PHONY: plan
plan: ## Show Terraform plan
	terraform plan -var-file=$(TF_VAR_FILE)

.PHONY: apply
apply: ## Apply Terraform changes
	terraform apply -var-file=$(TF_VAR_FILE) -auto-approve

.PHONY: destroy
destroy: ## Destroy Terraform-managed infrastructure
	terraform destroy -var-file=$(TF_VAR_FILE) -auto-approve

.PHONY: fmt
fmt: ## Format Terraform code
	terraform fmt -recursive

.PHONY: validate
validate: ## Validate Terraform code
	terraform validate

.PHONY: workspace
workspace: ## Create or switch to a workspace
	terraform workspace select $(WORKSPACE) || terraform workspace new $(WORKSPACE)

.PHONY: clean
clean: ## Clean Terraform files
	rm -rf .terraform
	rm -f .terraform.lock.hcl
	rm -f terraform.tfstate*

.PHONY: get-kubeconfig
get-kubeconfig: ## Get kubeconfig for EKS cluster
	aws eks update-kubeconfig --name cilium-test --region us-west-2

.PHONY: flux-check
flux-check: ## Check FluxCD installation
	kubectl get pods -n flux-system

.PHONY: cilium-check
cilium-check: ## Check Cilium installation
	kubectl get pods -n kube-system -l k8s-app=cilium

.PHONY: all
all: init validate plan apply ## Run init, validate, plan, and apply

.PHONY: lint
lint: ## Run Terraform lint
	terraform fmt -check
	terraform validate

.PHONY: output
output: ## Show Terraform outputs
	terraform output

.PHONY: state-list
state-list: ## List resources in Terraform state
	terraform state list

.PHONY: create-vars
create-vars: ## Create terraform.tfvars file template
	@if [ ! -f terraform.tfvars ]; then \
		echo 'github_username = ""' > terraform.tfvars; \
		echo 'github_token = ""' >> terraform.tfvars; \
		echo 'github_repository = ""' >> terraform.tfvars; \
		echo "Created terraform.tfvars template"; \
	else \
		echo "terraform.tfvars already exists"; \
	fi

.PHONY: refresh
refresh: ## Refresh Terraform state
	terraform refresh -var-file=$(TF_VAR_FILE)