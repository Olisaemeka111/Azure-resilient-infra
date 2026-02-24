terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110"
    }
  }

  backend "local" {}
}

provider "azurerm" {
  features {}
}

module "multi_region_secure_azure" {
  source = "../../modules/multi_region_secure_azure"

  name_prefix  = var.name_prefix
  tenant_id    = var.tenant_id

  primary_location   = var.primary_location
  secondary_location = var.secondary_location

  primary_rg_name   = var.primary_rg_name
  secondary_rg_name = var.secondary_rg_name

  primary_hub_address_space          = var.primary_hub_address_space
  secondary_hub_address_space        = var.secondary_hub_address_space
  primary_app_spoke_address_space    = var.primary_app_spoke_address_space
  primary_data_spoke_address_space   = var.primary_data_spoke_address_space
  secondary_app_spoke_address_space  = var.secondary_app_spoke_address_space
  secondary_data_spoke_address_space = var.secondary_data_spoke_address_space

  primary_hub_firewall_subnet_prefix   = var.primary_hub_firewall_subnet_prefix
  secondary_hub_firewall_subnet_prefix = var.secondary_hub_firewall_subnet_prefix

  primary_app_aks_subnet_prefix   = var.primary_app_aks_subnet_prefix
  secondary_app_aks_subnet_prefix = var.secondary_app_aks_subnet_prefix

  primary_data_sql_subnet_prefix   = var.primary_data_sql_subnet_prefix
  secondary_data_sql_subnet_prefix = var.secondary_data_sql_subnet_prefix

  aks_primary_node_count   = var.aks_primary_node_count
  aks_secondary_node_count = var.aks_secondary_node_count
  aks_node_size            = var.aks_node_size

  sql_admin_username          = var.sql_admin_username
  sql_admin_password          = var.sql_admin_password
  sql_sku_name                = var.sql_sku_name
  storage_account_name_prefix = var.storage_account_name_prefix

  ## New subnets
  primary_hub_bastion_subnet_prefix         = var.primary_hub_bastion_subnet_prefix
  primary_hub_gateway_subnet_prefix         = var.primary_hub_gateway_subnet_prefix
  primary_app_service_subnet_prefix         = var.primary_app_service_subnet_prefix
  primary_private_endpoints_subnet_prefix   = var.primary_private_endpoints_subnet_prefix
  secondary_hub_bastion_subnet_prefix       = var.secondary_hub_bastion_subnet_prefix
  secondary_hub_gateway_subnet_prefix       = var.secondary_hub_gateway_subnet_prefix
  secondary_app_service_subnet_prefix       = var.secondary_app_service_subnet_prefix
  secondary_private_endpoints_subnet_prefix = var.secondary_private_endpoints_subnet_prefix

  ## Optional services
  create_vpn_gateway = var.create_vpn_gateway
  create_app_service = var.create_app_service

  ## Shared platform services
  registry_name             = var.registry_name
  monitoring_retention_days = var.monitoring_retention_days
  alert_email               = var.alert_email
  subscription_id           = var.subscription_id
  security_contact_email    = var.security_contact_email
  allowed_locations         = var.allowed_locations
  ops_principal_id          = var.ops_principal_id

  tags = var.tags
}
