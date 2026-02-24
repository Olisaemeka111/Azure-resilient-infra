############################
## Azure Container Registry (Premium — required for private endpoints + geo-replication)
############################

resource "azurerm_container_registry" "this" {
  name                          = var.registry_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = "Premium"
  admin_enabled                 = false
  public_network_access_enabled = false

  georeplications {
    location                = var.secondary_location
    zone_redundancy_enabled = false
    tags                    = var.tags
  }

  network_rule_set {
    default_action = "Deny"
  }

  tags = var.tags
}

############################
## Private Endpoint for ACR
############################

resource "azurerm_private_endpoint" "acr" {
  name                = "${var.name_prefix}-pe-acr"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "acr-connection"
    private_connection_resource_id = azurerm_container_registry.this.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "acr-dns-group"
    private_dns_zone_ids = [var.acr_private_dns_zone_id]
  }
}

############################
## Diagnostic Settings
############################

resource "azurerm_monitor_diagnostic_setting" "acr" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.name_prefix}-acr-diag"
  target_resource_id         = azurerm_container_registry.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log { category = "ContainerRegistryRepositoryEvents" }
  enabled_log { category = "ContainerRegistryLoginEvents" }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
