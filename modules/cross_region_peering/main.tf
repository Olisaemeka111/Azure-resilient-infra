resource "azurerm_virtual_network_peering" "primary_to_secondary" {
  name                         = "${var.name_prefix}-pri-hub-to-sec-hub"
  resource_group_name          = var.primary_rg_name
  virtual_network_name         = var.primary_hub_vnet_name
  remote_virtual_network_id    = var.secondary_hub_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "secondary_to_primary" {
  name                         = "${var.name_prefix}-sec-hub-to-pri-hub"
  resource_group_name          = var.secondary_rg_name
  virtual_network_name         = var.secondary_hub_vnet_name
  remote_virtual_network_id    = var.primary_hub_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}
