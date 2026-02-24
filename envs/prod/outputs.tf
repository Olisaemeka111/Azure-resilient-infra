output "primary_rg_name" {
  description = "Name of the primary resource group."
  value       = module.multi_region_secure_azure.primary_rg_name
}

output "secondary_rg_name" {
  description = "Name of the secondary resource group."
  value       = module.multi_region_secure_azure.secondary_rg_name
}

output "aks_primary_name" {
  description = "Name of the primary AKS cluster."
  value       = module.multi_region_secure_azure.aks_primary_name
}

output "aks_secondary_name" {
  description = "Name of the secondary AKS cluster."
  value       = module.multi_region_secure_azure.aks_secondary_name
}

output "sql_primary_fqdn" {
  description = "FQDN of the primary SQL server."
  value       = module.multi_region_secure_azure.sql_primary_fqdn
}

output "sql_secondary_fqdn" {
  description = "FQDN of the secondary SQL server."
  value       = module.multi_region_secure_azure.sql_secondary_fqdn
}

output "sql_failover_group_id" {
  description = "Resource ID of the SQL auto-failover group."
  value       = module.multi_region_secure_azure.sql_failover_group_id
}

output "afd_endpoint_hostname" {
  description = "Azure Front Door global entry point hostname."
  value       = module.multi_region_secure_azure.afd_endpoint_hostname
}

output "acr_login_server" {
  description = "Login server URL of the Azure Container Registry."
  value       = module.multi_region_secure_azure.acr_login_server
}

output "monitoring_workspace_id" {
  description = "Resource ID of the shared Log Analytics Workspace."
  value       = module.multi_region_secure_azure.monitoring_workspace_id
}

output "primary_bastion_id" {
  description = "Resource ID of the primary Azure Bastion host."
  value       = module.multi_region_secure_azure.primary_bastion_id
}

output "secondary_bastion_id" {
  description = "Resource ID of the secondary Azure Bastion host."
  value       = module.multi_region_secure_azure.secondary_bastion_id
}

output "secondary_key_vault_id" {
  description = "Resource ID of the secondary Key Vault."
  value       = module.multi_region_secure_azure.secondary_key_vault_id
}

output "primary_firewall_private_ip" {
  description = "Private IP of the primary Azure Firewall."
  value       = module.multi_region_secure_azure.primary_firewall_private_ip
}

output "secondary_firewall_private_ip" {
  description = "Private IP of the secondary Azure Firewall."
  value       = module.multi_region_secure_azure.secondary_firewall_private_ip
}
