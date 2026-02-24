output "hub_vnet_id" {
  description = "Resource ID of the hub VNet."
  value       = azurerm_virtual_network.hub.id
}

output "hub_vnet_name" {
  description = "Name of the hub VNet (used for cross-region peering)."
  value       = azurerm_virtual_network.hub.name
}

output "app_spoke_vnet_id" {
  description = "Resource ID of the app spoke VNet."
  value       = azurerm_virtual_network.app_spoke.id
}

output "app_spoke_vnet_name" {
  description = "Name of the app spoke VNet."
  value       = azurerm_virtual_network.app_spoke.name
}

output "data_spoke_vnet_id" {
  description = "Resource ID of the data spoke VNet."
  value       = azurerm_virtual_network.data_spoke.id
}

output "data_spoke_vnet_name" {
  description = "Name of the data spoke VNet."
  value       = azurerm_virtual_network.data_spoke.name
}

output "data_sql_subnet_id" {
  description = "Resource ID of the SQL subnet in the data spoke (used for SQL VNet rules)."
  value       = azurerm_subnet.data_sql.id
}

output "app_aks_subnet_id" {
  description = "Resource ID of the AKS subnet in the app spoke."
  value       = azurerm_subnet.app_aks.id
}

output "aks_name" {
  description = "Name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.name
}

output "aks_principal_id" {
  description = "Principal ID of the AKS system-assigned managed identity."
  value       = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

output "storage_account_name" {
  description = "Name of the storage account."
  value       = azurerm_storage_account.this.name
}

output "storage_account_id" {
  description = "Resource ID of the storage account."
  value       = azurerm_storage_account.this.id
}

output "key_vault_id" {
  description = "Resource ID of the Key Vault (null if not created)."
  value       = one(azurerm_key_vault.this[*].id)
}

output "firewall_private_ip" {
  description = "Private IP address of the Azure Firewall."
  value       = azurerm_firewall.this.ip_configuration[0].private_ip_address
}

output "private_endpoints_subnet_id" {
  description = "Resource ID of the private endpoints subnet in the data spoke."
  value       = azurerm_subnet.private_endpoints.id
}

output "kubelet_identity_object_id" {
  description = "Object ID of the AKS kubelet managed identity (used for ACR pull)."
  value       = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

output "bastion_id" {
  description = "Resource ID of the Azure Bastion host."
  value       = azurerm_bastion_host.this.id
}

output "vpn_gateway_id" {
  description = "Resource ID of the VPN Gateway (null if not created)."
  value       = one(azurerm_virtual_network_gateway.this[*].id)
}

output "app_service_id" {
  description = "Resource ID of the App Service (null if not created)."
  value       = one(azurerm_linux_web_app.this[*].id)
}

output "app_service_default_hostname" {
  description = "Default hostname of the App Service (null if not created)."
  value       = one(azurerm_linux_web_app.this[*].default_hostname)
}
