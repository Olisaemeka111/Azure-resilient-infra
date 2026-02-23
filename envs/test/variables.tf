variable "name_prefix" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "primary_location" {
  type    = string
  default = "uksouth"
}

variable "secondary_location" {
  type    = string
  default = "ukwest"
}

variable "primary_rg_name" {
  type = string
}

variable "secondary_rg_name" {
  type = string
}

variable "primary_hub_address_space" {
  type = string
}

variable "secondary_hub_address_space" {
  type = string
}

variable "primary_app_spoke_address_space" {
  type = string
}

variable "primary_data_spoke_address_space" {
  type = string
}

variable "secondary_app_spoke_address_space" {
  type = string
}

variable "secondary_data_spoke_address_space" {
  type = string
}

variable "primary_hub_firewall_subnet_prefix" {
  type = string
}

variable "secondary_hub_firewall_subnet_prefix" {
  type = string
}

variable "primary_app_aks_subnet_prefix" {
  type = string
}

variable "secondary_app_aks_subnet_prefix" {
  type = string
}

variable "primary_data_sql_subnet_prefix" {
  type = string
}

variable "secondary_data_sql_subnet_prefix" {
  type = string
}

variable "aks_primary_node_count" {
  type    = number
  default = 3
}

variable "aks_secondary_node_count" {
  type    = number
  default = 1
}

variable "aks_node_size" {
  type    = string
  default = "Standard_DS3_v2"
}

variable "sql_admin_username" {
  type = string
}

variable "sql_admin_password" {
  type      = string
  sensitive = true
}

variable "sql_sku_name" {
  type    = string
  default = "GP_Gen5_2"
}

variable "storage_account_name_prefix" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

