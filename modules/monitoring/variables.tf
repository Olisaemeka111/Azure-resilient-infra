variable "name_prefix" {
  type        = string
  description = "Prefix for monitoring resource names."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for the Log Analytics Workspace."
}

variable "location" {
  type        = string
  description = "Azure region for the workspace."
}

variable "retention_days" {
  type        = number
  description = "Log retention period in days."
  default     = 30
}

variable "alert_email" {
  type        = string
  description = "Email address for critical operational alerts."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to monitoring resources."
  default     = {}
}
