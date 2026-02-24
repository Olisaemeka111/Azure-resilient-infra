output "primary_rg_name" {
  description = "Name of the primary resource group."
  value       = azurerm_resource_group.primary.name
}

output "secondary_rg_name" {
  description = "Name of the secondary resource group."
  value       = azurerm_resource_group.secondary.name
}

output "aks_primary_name" {
  description = "Name of the primary AKS cluster."
  value       = module.primary_region.aks_name
}

output "aks_secondary_name" {
  description = "Name of the secondary AKS cluster."
  value       = module.secondary_region.aks_name
}

output "sql_primary_fqdn" {
  description = "FQDN of the primary SQL server."
  value       = module.sql.primary_sql_fqdn
}

output "sql_secondary_fqdn" {
  description = "FQDN of the secondary SQL server."
  value       = module.sql.secondary_sql_fqdn
}

output "sql_failover_group_id" {
  description = "Resource ID of the SQL auto-failover group."
  value       = module.sql.failover_group_id
}

output "afd_endpoint_hostname" {
  description = "Hostname of the Azure Front Door global entry point."
  value       = module.front_door.endpoint_hostname
}

output "primary_storage_account_name" {
  description = "Name of the primary region storage account."
  value       = module.primary_region.storage_account_name
}

output "secondary_storage_account_name" {
  description = "Name of the secondary region storage account."
  value       = module.secondary_region.storage_account_name
}

output "secondary_key_vault_id" {
  description = "Resource ID of the Key Vault in the secondary region."
  value       = module.secondary_region.key_vault_id
}

output "primary_firewall_private_ip" {
  description = "Private IP of the primary region Azure Firewall."
  value       = module.primary_region.firewall_private_ip
}

output "secondary_firewall_private_ip" {
  description = "Private IP of the secondary region Azure Firewall."
  value       = module.secondary_region.firewall_private_ip
}

output "acr_login_server" {
  description = "Login server URL of the Azure Container Registry."
  value       = module.acr.acr_login_server
}

output "acr_name" {
  description = "Name of the Azure Container Registry."
  value       = module.acr.acr_name
}

output "monitoring_workspace_id" {
  description = "Resource ID of the shared Log Analytics Workspace."
  value       = module.monitoring.workspace_id
}

output "primary_bastion_id" {
  description = "Resource ID of the primary region Azure Bastion host."
  value       = module.primary_region.bastion_id
}

output "secondary_bastion_id" {
  description = "Resource ID of the secondary region Azure Bastion host."
  value       = module.secondary_region.bastion_id
}

output "primary_app_service_hostname" {
  description = "Default hostname of the primary App Service (null if not deployed)."
  value       = module.primary_region.app_service_default_hostname
}

output "secondary_app_service_hostname" {
  description = "Default hostname of the secondary App Service (null if not deployed)."
  value       = module.secondary_region.app_service_default_hostname
}
