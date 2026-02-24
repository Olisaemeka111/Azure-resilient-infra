############################
## Private DNS Zones
## All zones live in the primary resource group and are linked to every VNet.
############################

resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.primary.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.primary.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone" "keyvault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.primary.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone" "acr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.primary.name
  tags                = var.tags
}

############################
## VNet Links — every spoke and hub in both regions linked to each DNS zone.
############################

locals {
  dns_vnet_links = {
    primary_hub        = module.primary_region.hub_vnet_id
    primary_app_spoke  = module.primary_region.app_spoke_vnet_id
    primary_data_spoke = module.primary_region.data_spoke_vnet_id
    secondary_hub      = module.secondary_region.hub_vnet_id
    secondary_app_spoke  = module.secondary_region.app_spoke_vnet_id
    secondary_data_spoke = module.secondary_region.data_spoke_vnet_id
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql" {
  for_each = local.dns_vnet_links

  name                  = "${each.key}-sql-link"
  resource_group_name   = azurerm_resource_group.primary.name
  private_dns_zone_name = azurerm_private_dns_zone.sql.name
  virtual_network_id    = each.value
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  for_each = local.dns_vnet_links

  name                  = "${each.key}-blob-link"
  resource_group_name   = azurerm_resource_group.primary.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = each.value
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault" {
  for_each = local.dns_vnet_links

  name                  = "${each.key}-kv-link"
  resource_group_name   = azurerm_resource_group.primary.name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault.name
  virtual_network_id    = each.value
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr" {
  for_each = local.dns_vnet_links

  name                  = "${each.key}-acr-link"
  resource_group_name   = azurerm_resource_group.primary.name
  private_dns_zone_name = azurerm_private_dns_zone.acr.name
  virtual_network_id    = each.value
  registration_enabled  = false
  tags                  = var.tags
}
