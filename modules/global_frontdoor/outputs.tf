output "endpoint_hostname" {
  description = "Hostname of the Azure Front Door endpoint."
  value       = azurerm_cdn_frontdoor_endpoint.this.host_name
}

output "profile_id" {
  description = "Resource ID of the Front Door profile."
  value       = azurerm_cdn_frontdoor_profile.this.id
}
