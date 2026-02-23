variable "name_prefix" {
  type        = string
  description = "Prefix used for all resource names in this region."
}

variable "location" {
  type        = string
  description = "Azure region for this regional stack."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name to deploy regional resources into."
}

variable "hub_address_space" {
  type        = string
  description = "Address space for the regional hub VNet."
}

variable "app_spoke_address_space" {
  type        = string
  description = "Address space for the app spoke VNet."
}

variable "data_spoke_address_space" {
  type        = string
  description = "Address space for the data spoke VNet."
}

variable "hub_firewall_subnet_prefix" {
  type        = string
  description = "Subnet prefix for Azure Firewall subnet in the hub."
}

variable "app_aks_subnet_prefix" {
  type        = string
  description = "Subnet prefix for AKS in the app spoke."
}

variable "data_sql_subnet_prefix" {
  type        = string
  description = "Subnet prefix for SQL in the data spoke."
}

variable "aks_node_count" {
  type        = number
  description = "Node count for the AKS cluster."
}

variable "aks_node_size" {
  type        = string
  description = "VM size for AKS nodes."
}

variable "storage_account_name" {
  type        = string
  description = "Storage account name for this region."
}

variable "create_key_vault" {
  type        = bool
  description = "Whether to create a Key Vault in this region (true for secondary in this design)."
  default     = false
}

variable "tenant_id" {
  type        = string
  description = "Tenant ID used if Key Vault is created."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources."
  default     = {}
}

