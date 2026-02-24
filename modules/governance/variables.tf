variable "subscription_id" {
  type        = string
  description = "Azure subscription ID for policy and Defender scope."
}

variable "security_contact_email" {
  type        = string
  description = "Email for Microsoft Defender for Cloud security alerts."
}

variable "allowed_locations" {
  type        = list(string)
  description = "Allowed Azure regions enforced via Azure Policy."
  default     = ["uksouth", "ukwest"]
}

variable "resource_group_ids" {
  type        = list(string)
  description = "Resource group IDs to grant the ops team Contributor access."
  default     = []
}

variable "ops_principal_id" {
  type        = string
  description = "Object ID of the ops Azure AD group for RBAC assignments. Set null to skip."
  default     = null
}
