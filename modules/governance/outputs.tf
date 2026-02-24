output "security_contact_id" {
  description = "Resource ID of the Defender for Cloud security contact."
  value       = azurerm_security_center_contact.this.id
}
