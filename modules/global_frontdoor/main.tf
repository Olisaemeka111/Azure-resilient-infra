resource "azurerm_cdn_frontdoor_profile" "this" {
  name                = "${var.name_prefix}-afd-profile"
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"
  tags                = var.tags
}

resource "azurerm_cdn_frontdoor_endpoint" "this" {
  name                     = "${var.name_prefix}-afd-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
}

output "endpoint_hostname" {
  value = azurerm_cdn_frontdoor_endpoint.this.host_name
}

