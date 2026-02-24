resource "azurerm_resource_group" "primary" {
  name     = var.primary_rg_name
  location = var.primary_location
  tags     = var.tags
}

resource "azurerm_resource_group" "secondary" {
  name     = var.secondary_rg_name
  location = var.secondary_location
  tags     = var.tags
}
