############################
## App Service (optional — primary region only in this design)
############################

resource "azurerm_service_plan" "this" {
  count               = var.create_app_service ? 1 : 0
  name                = "${var.name_prefix}-asp"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.app_service_sku_name
  tags                = var.tags
}

resource "azurerm_linux_web_app" "this" {
  count                     = var.create_app_service ? 1 : 0
  name                      = "${var.name_prefix}-app"
  resource_group_name       = var.resource_group_name
  location                  = var.location
  service_plan_id           = azurerm_service_plan.this[0].id
  virtual_network_subnet_id = azurerm_subnet.app_service[0].id
  https_only                = true

  site_config {
    always_on = true

    application_stack {
      node_version = "18-lts"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
