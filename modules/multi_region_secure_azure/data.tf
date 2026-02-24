module "sql" {
  source = "../sql_geo_replica"

  name_prefix        = var.name_prefix
  primary_rg_name    = azurerm_resource_group.primary.name
  primary_location   = azurerm_resource_group.primary.location
  secondary_rg_name  = azurerm_resource_group.secondary.name
  secondary_location = azurerm_resource_group.secondary.location

  sql_admin_username = var.sql_admin_username
  sql_admin_password = var.sql_admin_password
  sql_sku_name       = var.sql_sku_name

  primary_data_subnet_id   = module.primary_region.data_sql_subnet_id
  secondary_data_subnet_id = module.secondary_region.data_sql_subnet_id

  failover_grace_minutes = var.sql_failover_grace_minutes

  tags = var.tags
}
