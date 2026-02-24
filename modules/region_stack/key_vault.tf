############################
## Key Vault (secondary region only)
############################

resource "azurerm_key_vault" "this" {
  count                           = var.create_key_vault ? 1 : 0
  name                            = "${var.name_prefix}-kv"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  tenant_id                       = var.tenant_id
  sku_name                        = "standard"
  soft_delete_retention_days      = 90
  purge_protection_enabled        = true
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true

  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = [azurerm_subnet.data_sql.id, azurerm_subnet.app_aks.id]
  }

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "aks" {
  count        = var.create_key_vault ? 1 : 0
  key_vault_id = azurerm_key_vault.this[0].id
  tenant_id    = var.tenant_id
  object_id    = azurerm_kubernetes_cluster.aks.identity[0].principal_id

  secret_permissions      = ["Get", "List"]
  key_permissions         = ["Get", "List", "UnwrapKey", "WrapKey"]
  certificate_permissions = ["Get", "List"]
}
