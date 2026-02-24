variable "name_prefix" {
  type        = string
  description = "Prefix for container registry resource names."
}

variable "registry_name" {
  type        = string
  description = "Name of the Azure Container Registry (globally unique, alphanumeric, 5-50 chars)."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for the container registry."
}

variable "location" {
  type        = string
  description = "Primary location for the container registry."
}

variable "secondary_location" {
  type        = string
  description = "Secondary location for geo-replication."
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "Subnet ID where the ACR private endpoint will be created."
}

variable "acr_private_dns_zone_id" {
  type        = string
  description = "Private DNS zone ID for ACR (privatelink.azurecr.io)."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics Workspace ID for ACR diagnostic settings."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to container registry resources."
  default     = {}
}
