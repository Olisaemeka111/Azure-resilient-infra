variable "name_prefix" {
  type        = string
  description = "Prefix for SQL server and database names."
}

variable "primary_rg_name" {
  type        = string
  description = "Primary region resource group name."
}

variable "primary_location" {
  type        = string
  description = "Primary region location."
}

variable "secondary_rg_name" {
  type        = string
  description = "Secondary region resource group name."
}

variable "secondary_location" {
  type        = string
  description = "Secondary region location."
}

variable "sql_admin_username" {
  type        = string
  description = "SQL Server admin username."
}

variable "sql_admin_password" {
  type        = string
  description = "SQL Server admin password."
  sensitive   = true
}

variable "sql_sku_name" {
  type        = string
  description = "SKU name for Azure SQL database."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to SQL resources."
  default     = {}
}

