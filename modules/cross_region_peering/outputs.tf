output "primary_to_secondary_peering_id" {
  description = "Resource ID of the primary-to-secondary hub peering."
  value       = azurerm_virtual_network_peering.primary_to_secondary.id
}

output "secondary_to_primary_peering_id" {
  description = "Resource ID of the secondary-to-primary hub peering."
  value       = azurerm_virtual_network_peering.secondary_to_primary.id
}
