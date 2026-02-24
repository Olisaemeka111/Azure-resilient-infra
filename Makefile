.PHONY: init plan apply destroy validate fmt lint help

ENV        ?= dev
ENV_DIR     = envs/$(ENV)
TFVARS      = terraform.tfvars

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

init: ## Initialise Terraform for ENV (default: dev). Usage: make init ENV=prod
	terraform -chdir=$(ENV_DIR) init -upgrade

validate: ## Validate Terraform configuration for ENV
	terraform -chdir=$(ENV_DIR) validate

fmt: ## Format all Terraform files recursively
	terraform fmt -recursive .

plan: ## Plan Terraform changes for ENV. Usage: make plan ENV=prod
	terraform -chdir=$(ENV_DIR) plan -var-file=$(TFVARS) -out=terraform.tfplan

apply: ## Apply the last plan for ENV. Usage: make apply ENV=prod
	terraform -chdir=$(ENV_DIR) apply terraform.tfplan

apply-auto: ## Plan + apply without manual approval (use with caution)
	terraform -chdir=$(ENV_DIR) apply -var-file=$(TFVARS) -auto-approve

destroy: ## Destroy all resources for ENV. Usage: make destroy ENV=prod
	@echo "WARNING: This will destroy all resources in $(ENV)!"
	terraform -chdir=$(ENV_DIR) destroy -var-file=$(TFVARS)

lint: ## Run tflint against all modules and envs
	tflint --recursive

output: ## Show outputs for ENV
	terraform -chdir=$(ENV_DIR) output

state-list: ## List resources in state for ENV
	terraform -chdir=$(ENV_DIR) state list

init-all: ## Initialise all environments
	$(MAKE) init ENV=dev
	$(MAKE) init ENV=test
	$(MAKE) init ENV=prod

validate-all: ## Validate all environments
	$(MAKE) validate ENV=dev
	$(MAKE) validate ENV=test
	$(MAKE) validate ENV=prod
