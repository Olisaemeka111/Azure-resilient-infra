variable "name_prefix" {
  type        = string
  description = "Prefix for Front Door resources."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name where Front Door profile will be created."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to Front Door resources."
  default     = {}
}

