############################
## Monitoring (Log Analytics + Action Group) — shared, lives in primary RG
############################

module "monitoring" {
  source = "../monitoring"

  name_prefix         = var.name_prefix
  resource_group_name = azurerm_resource_group.primary.name
  location            = azurerm_resource_group.primary.location
  retention_days      = var.monitoring_retention_days
  alert_email         = var.alert_email
  tags                = var.tags
}

############################
## Container Registry (Premium, private, geo-replicated)
############################

module "acr" {
  source = "../container_registry"

  name_prefix                = var.name_prefix
  registry_name              = var.registry_name
  resource_group_name        = azurerm_resource_group.primary.name
  location                   = azurerm_resource_group.primary.location
  secondary_location         = azurerm_resource_group.secondary.location
  private_endpoint_subnet_id = module.primary_region.private_endpoints_subnet_id
  acr_private_dns_zone_id    = azurerm_private_dns_zone.acr.id
  log_analytics_workspace_id = module.monitoring.workspace_id
  tags                       = var.tags
}

############################
## Governance (Defender for Cloud, Azure Policy, RBAC)
############################

module "governance" {
  source = "../governance"

  subscription_id       = var.subscription_id
  security_contact_email = var.security_contact_email
  allowed_locations     = var.allowed_locations
  resource_group_ids    = [
    azurerm_resource_group.primary.id,
    azurerm_resource_group.secondary.id,
  ]
  ops_principal_id = var.ops_principal_id
}

############################
## Azure Front Door (global load balancer / WAF)
############################

module "front_door" {
  source = "../global_frontdoor"

  name_prefix         = var.name_prefix
  resource_group_name = azurerm_resource_group.primary.name
  tags                = var.tags
}
