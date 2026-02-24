############################
## Regional Stacks (Hub-Spoke + AKS + Storage + optional services)
############################

module "primary_region" {
  source = "../region_stack"

  name_prefix         = "${var.name_prefix}-pri"
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name

  ## Network address spaces
  hub_address_space        = var.primary_hub_address_space
  app_spoke_address_space  = var.primary_app_spoke_address_space
  data_spoke_address_space = var.primary_data_spoke_address_space

  ## Hub subnets
  hub_firewall_subnet_prefix = var.primary_hub_firewall_subnet_prefix
  hub_bastion_subnet_prefix  = var.primary_hub_bastion_subnet_prefix
  hub_gateway_subnet_prefix  = var.primary_hub_gateway_subnet_prefix

  ## App spoke subnets
  app_aks_subnet_prefix     = var.primary_app_aks_subnet_prefix
  app_service_subnet_prefix = var.primary_app_service_subnet_prefix

  ## Data spoke subnets
  data_sql_subnet_prefix          = var.primary_data_sql_subnet_prefix
  private_endpoints_subnet_prefix = var.primary_private_endpoints_subnet_prefix

  ## AKS
  aks_node_count     = var.aks_primary_node_count
  aks_node_size      = var.aks_node_size
  aks_service_cidr   = local.primary_aks_service_cidr
  aks_dns_service_ip = local.primary_aks_dns_service_ip

  ## Storage
  storage_account_name = "${var.storage_account_name_prefix}pri"

  ## Optional services
  create_vpn_gateway = var.create_vpn_gateway
  create_app_service = var.create_app_service
  create_key_vault   = false

  ## Identity & monitoring
  tenant_id                  = var.tenant_id
  log_analytics_workspace_id = module.monitoring.workspace_id

  tags = merge(var.tags, { role = "primary" })
}

module "secondary_region" {
  source = "../region_stack"

  name_prefix         = "${var.name_prefix}-sec"
  location            = azurerm_resource_group.secondary.location
  resource_group_name = azurerm_resource_group.secondary.name

  ## Network address spaces
  hub_address_space        = var.secondary_hub_address_space
  app_spoke_address_space  = var.secondary_app_spoke_address_space
  data_spoke_address_space = var.secondary_data_spoke_address_space

  ## Hub subnets
  hub_firewall_subnet_prefix = var.secondary_hub_firewall_subnet_prefix
  hub_bastion_subnet_prefix  = var.secondary_hub_bastion_subnet_prefix
  hub_gateway_subnet_prefix  = var.secondary_hub_gateway_subnet_prefix

  ## App spoke subnets
  app_aks_subnet_prefix     = var.secondary_app_aks_subnet_prefix
  app_service_subnet_prefix = var.secondary_app_service_subnet_prefix

  ## Data spoke subnets
  data_sql_subnet_prefix          = var.secondary_data_sql_subnet_prefix
  private_endpoints_subnet_prefix = var.secondary_private_endpoints_subnet_prefix

  ## AKS
  aks_node_count     = var.aks_secondary_node_count
  aks_node_size      = var.aks_node_size
  aks_service_cidr   = local.secondary_aks_service_cidr
  aks_dns_service_ip = local.secondary_aks_dns_service_ip

  ## Storage
  storage_account_name = "${var.storage_account_name_prefix}sec"

  ## Optional services
  create_vpn_gateway = var.create_vpn_gateway
  create_app_service = var.create_app_service
  create_key_vault   = true

  ## Identity & monitoring
  tenant_id                  = var.tenant_id
  log_analytics_workspace_id = module.monitoring.workspace_id

  tags = merge(var.tags, { role = "secondary" })
}

############################
## AcrPull — grant both AKS kubelet identities pull access to the shared ACR
############################

resource "azurerm_role_assignment" "primary_aks_acr_pull" {
  principal_id                     = module.primary_region.kubelet_identity_object_id
  role_definition_name             = "AcrPull"
  scope                            = module.acr.acr_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "secondary_aks_acr_pull" {
  principal_id                     = module.secondary_region.kubelet_identity_object_id
  role_definition_name             = "AcrPull"
  scope                            = module.acr.acr_id
  skip_service_principal_aad_check = true
}
