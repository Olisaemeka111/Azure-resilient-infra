resource "azurerm_mssql_server" "primary" {
  name                         = "${var.name_prefix}-sql-primary"
  resource_group_name          = var.primary_rg_name
  location                     = var.primary_location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
  minimum_tls_version          = "1.2"
  tags                         = var.tags
}

resource "azurerm_mssql_server" "secondary" {
  name                         = "${var.name_prefix}-sql-secondary"
  resource_group_name          = var.secondary_rg_name
  location                     = var.secondary_location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
  minimum_tls_version          = "1.2"
  tags                         = var.tags
}

resource "azurerm_mssql_database" "primary" {
  name           = "${var.name_prefix}-sqldb"
  server_id      = azurerm_mssql_server.primary.id
  sku_name       = var.sql_sku_name
  zone_redundant = true
  tags           = var.tags
}

resource "azurerm_mssql_database" "secondary_geo_replica" {
  name               = azurerm_mssql_database.primary.name
  server_id          = azurerm_mssql_server.secondary.id
  create_mode        = "Secondary"
  source_database_id = azurerm_mssql_database.primary.id
  sku_name           = var.sql_sku_name
  zone_redundant     = false
  tags               = var.tags
}

output "primary_sql_fqdn" {
  value = azurerm_mssql_server.primary.fully_qualified_domain_name
}

