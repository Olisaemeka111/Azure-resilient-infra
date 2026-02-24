############################
## Storage Account (GRS)
############################

resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  allow_nested_items_to_be_public = false
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

resource "azurerm_storage_account_network_rules" "this" {
  storage_account_id = azurerm_storage_account.this.id
  default_action     = "Deny"
  bypass             = ["AzureServices"]

  virtual_network_subnet_ids = [
    azurerm_subnet.app_aks.id,
    azurerm_subnet.data_sql.id,
    azurerm_subnet.private_endpoints.id,
  ]
}
