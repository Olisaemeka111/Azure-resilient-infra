variable "name_prefix" {
  type        = string
  description = "Prefix used for all resource names."
}

variable "primary_location" {
  type        = string
  description = "Azure region for the primary deployment (e.g. UK South)."
}

variable "secondary_location" {
  type        = string
  description = "Azure region for the secondary deployment (e.g. UK West)."
}

variable "primary_rg_name" {
  type        = string
  description = "Name of the primary resource group."
}

variable "secondary_rg_name" {
  type        = string
  description = "Name of the secondary resource group."
}

variable "primary_hub_address_space" {
  type        = string
  description = "Address space for the primary hub VNet."
}

variable "secondary_hub_address_space" {
  type        = string
  description = "Address space for the secondary hub VNet."
}

variable "primary_app_spoke_address_space" {
  type        = string
  description = "Address space for the primary app spoke VNet."
}

variable "primary_data_spoke_address_space" {
  type        = string
  description = "Address space for the primary data spoke VNet."
}

variable "secondary_app_spoke_address_space" {
  type        = string
  description = "Address space for the secondary app spoke VNet."
}

variable "secondary_data_spoke_address_space" {
  type        = string
  description = "Address space for the secondary data spoke VNet."
}

variable "primary_hub_firewall_subnet_prefix" {
  type        = string
  description = "Subnet prefix for Azure Firewall subnet in primary hub."
}

variable "secondary_hub_firewall_subnet_prefix" {
  type        = string
  description = "Subnet prefix for Azure Firewall subnet in secondary hub."
}

variable "primary_app_aks_subnet_prefix" {
  type        = string
  description = "Subnet prefix for AKS in primary app spoke."
}

variable "secondary_app_aks_subnet_prefix" {
  type        = string
  description = "Subnet prefix for AKS in secondary app spoke."
}

variable "primary_data_sql_subnet_prefix" {
  type        = string
  description = "Subnet prefix for SQL in primary data spoke."
}

variable "secondary_data_sql_subnet_prefix" {
  type        = string
  description = "Subnet prefix for SQL in secondary data spoke."
}

variable "aks_primary_node_count" {
  type        = number
  description = "Node count for primary AKS cluster."
  default     = 3
}

variable "aks_secondary_node_count" {
  type        = number
  description = "Node count for secondary AKS cluster."
  default     = 1
}

variable "aks_node_size" {
  type        = string
  description = "VM size for AKS nodes."
  default     = "Standard_DS3_v2"
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
  description = "SKU name for Azure SQL database (e.g. GP_Gen5_2)."
  default     = "GP_Gen5_2"
}

variable "storage_account_name_prefix" {
  type        = string
  description = "Prefix for storage account names (must be globally unique and <= 21 chars)."
}

variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID used for Key Vault."
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to all resources."
  default     = {}
}

