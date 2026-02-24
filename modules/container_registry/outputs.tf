output "acr_id" {
  description = "Resource ID of the Azure Container Registry."
  value       = azurerm_container_registry.this.id
}

output "acr_login_server" {
  description = "Login server URL for the container registry."
  value       = azurerm_container_registry.this.login_server
}

output "acr_name" {
  description = "Name of the container registry."
  value       = azurerm_container_registry.this.name
}
