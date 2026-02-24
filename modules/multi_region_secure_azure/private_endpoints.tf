############################
## Private Endpoints
## SQL (primary + secondary), Storage (primary + secondary), Key Vault (secondary).
## ACR private endpoint is managed inside modules/container_registry.
############################

## ── SQL Primary ────────────────────────────────────────────────────────────
resource "azurerm_private_endpoint" "sql_primary" {
  name                = "${var.name_prefix}-pri-sql-pe"
  resource_group_name = azurerm_resource_group.primary.name
  location            = azurerm_resource_group.primary.location
  subnet_id           = module.primary_region.private_endpoints_subnet_id

  private_service_connection {
    name                           = "${var.name_prefix}-pri-sql-psc"
    private_connection_resource_id = module.sql.primary_server_id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "sql-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql.id]
  }

  tags = var.tags
}

## ── SQL Secondary ──────────────────────────────────────────────────────────
resource "azurerm_private_endpoint" "sql_secondary" {
  name                = "${var.name_prefix}-sec-sql-pe"
  resource_group_name = azurerm_resource_group.secondary.name
  location            = azurerm_resource_group.secondary.location
  subnet_id           = module.secondary_region.private_endpoints_subnet_id

  private_service_connection {
    name                           = "${var.name_prefix}-sec-sql-psc"
    private_connection_resource_id = module.sql.secondary_server_id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "sql-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql.id]
  }

  tags = var.tags
}

## ── Storage Primary ────────────────────────────────────────────────────────
resource "azurerm_private_endpoint" "storage_primary" {
  name                = "${var.name_prefix}-pri-stor-pe"
  resource_group_name = azurerm_resource_group.primary.name
  location            = azurerm_resource_group.primary.location
  subnet_id           = module.primary_region.private_endpoints_subnet_id

  private_service_connection {
    name                           = "${var.name_prefix}-pri-stor-psc"
    private_connection_resource_id = module.primary_region.storage_account_id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "blob-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }

  tags = var.tags
}

## ── Storage Secondary ──────────────────────────────────────────────────────
resource "azurerm_private_endpoint" "storage_secondary" {
  name                = "${var.name_prefix}-sec-stor-pe"
  resource_group_name = azurerm_resource_group.secondary.name
  location            = azurerm_resource_group.secondary.location
  subnet_id           = module.secondary_region.private_endpoints_subnet_id

  private_service_connection {
    name                           = "${var.name_prefix}-sec-stor-psc"
    private_connection_resource_id = module.secondary_region.storage_account_id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "blob-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }

  tags = var.tags
}

## ── Key Vault Secondary ────────────────────────────────────────────────────
## Secondary Key Vault is always created (create_key_vault = true for secondary).
resource "azurerm_private_endpoint" "keyvault_secondary" {
  name                = "${var.name_prefix}-sec-kv-pe"
  resource_group_name = azurerm_resource_group.secondary.name
  location            = azurerm_resource_group.secondary.location
  subnet_id           = module.secondary_region.private_endpoints_subnet_id

  private_service_connection {
    name                           = "${var.name_prefix}-sec-kv-psc"
    private_connection_resource_id = module.secondary_region.key_vault_id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "kv-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.keyvault.id]
  }

  tags = var.tags
}
