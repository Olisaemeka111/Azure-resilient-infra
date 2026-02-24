output "primary_sql_fqdn" {
  description = "Fully qualified domain name of the primary SQL server."
  value       = azurerm_mssql_server.primary.fully_qualified_domain_name
}

output "secondary_sql_fqdn" {
  description = "Fully qualified domain name of the secondary SQL server."
  value       = azurerm_mssql_server.secondary.fully_qualified_domain_name
}

output "failover_group_id" {
  description = "Resource ID of the SQL auto-failover group."
  value       = azurerm_mssql_failover_group.this.id
}

output "primary_server_id" {
  description = "Resource ID of the primary SQL server."
  value       = azurerm_mssql_server.primary.id
}

output "secondary_server_id" {
  description = "Resource ID of the secondary SQL server."
  value       = azurerm_mssql_server.secondary.id
}
