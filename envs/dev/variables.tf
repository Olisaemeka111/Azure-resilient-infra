variable "name_prefix" {
  type        = string
  description = "Short prefix used in all resource names (e.g. 'mr-secure-dev')."
}

variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID for Key Vault and identity configurations."
}

variable "primary_location" {
  type        = string
  description = "Azure region for the primary deployment (e.g. 'uksouth')."
  default     = "uksouth"
}

variable "secondary_location" {
  type        = string
  description = "Azure region for the secondary deployment (e.g. 'ukwest')."
  default     = "ukwest"
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
  description = "Address space for the primary hub VNet (e.g. '10.0.0.0/16')."
}

variable "secondary_hub_address_space" {
  type        = string
  description = "Address space for the secondary hub VNet (e.g. '10.1.0.0/16')."
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
  description = "Subnet prefix for Azure Firewall in the primary hub. Must be at least /26."
}

variable "secondary_hub_firewall_subnet_prefix" {
  type        = string
  description = "Subnet prefix for Azure Firewall in the secondary hub. Must be at least /26."
}

variable "primary_app_aks_subnet_prefix" {
  type        = string
  description = "Subnet prefix for AKS nodes in the primary app spoke."
}

variable "secondary_app_aks_subnet_prefix" {
  type        = string
  description = "Subnet prefix for AKS nodes in the secondary app spoke."
}

variable "primary_data_sql_subnet_prefix" {
  type        = string
  description = "Subnet prefix for SQL in the primary data spoke."
}

variable "secondary_data_sql_subnet_prefix" {
  type        = string
  description = "Subnet prefix for SQL in the secondary data spoke."
}

variable "aks_primary_node_count" {
  type        = number
  description = "Node count for the primary AKS cluster."
  default     = 3
}

variable "aks_secondary_node_count" {
  type        = number
  description = "Node count for the secondary (standby) AKS cluster."
  default     = 1
}

variable "aks_node_size" {
  type        = string
  description = "VM size for AKS nodes (e.g. 'Standard_DS3_v2')."
  default     = "Standard_DS3_v2"
}

variable "sql_admin_username" {
  type        = string
  description = "Administrator username for SQL Server. Do not use reserved names like 'sa' or 'admin'."
}

variable "sql_admin_password" {
  type        = string
  description = "Administrator password for SQL Server. Provide via TF_VAR_sql_admin_password — never commit this value."
  sensitive   = true
}

variable "sql_sku_name" {
  type        = string
  description = "SKU for Azure SQL Database (e.g. 'GP_Gen5_2')."
  default     = "GP_Gen5_2"
}

variable "storage_account_name_prefix" {
  type        = string
  description = "Prefix for storage account names. Lowercase alphanumeric, max 21 chars (suffix 'pri'/'sec' appended, max total 24)."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources in this environment."
  default     = {}
}

############################
## New Subnets
############################

variable "primary_hub_bastion_subnet_prefix" {
  type        = string
  description = "Subnet prefix for AzureBastionSubnet in the primary hub. Must be at least /26."
}

variable "primary_hub_gateway_subnet_prefix" {
  type        = string
  description = "Subnet prefix for GatewaySubnet in the primary hub. Required when create_vpn_gateway = true."
  default     = ""
}

variable "primary_app_service_subnet_prefix" {
  type        = string
  description = "Subnet prefix for App Service VNet integration in the primary app spoke."
  default     = ""
}

variable "primary_private_endpoints_subnet_prefix" {
  type        = string
  description = "Subnet prefix for private endpoints in the primary data spoke."
}

variable "secondary_hub_bastion_subnet_prefix" {
  type        = string
  description = "Subnet prefix for AzureBastionSubnet in the secondary hub. Must be at least /26."
}

variable "secondary_hub_gateway_subnet_prefix" {
  type        = string
  description = "Subnet prefix for GatewaySubnet in the secondary hub. Required when create_vpn_gateway = true."
  default     = ""
}

variable "secondary_app_service_subnet_prefix" {
  type        = string
  description = "Subnet prefix for App Service VNet integration in the secondary app spoke."
  default     = ""
}

variable "secondary_private_endpoints_subnet_prefix" {
  type        = string
  description = "Subnet prefix for private endpoints in the secondary data spoke."
}

############################
## Optional Services
############################

variable "create_vpn_gateway" {
  type        = bool
  description = "Whether to deploy VPN Gateways in both regions."
  default     = false
}

variable "create_app_service" {
  type        = bool
  description = "Whether to deploy App Services in both regions."
  default     = false
}

############################
## Shared Platform Services
############################

variable "registry_name" {
  type        = string
  description = "Name of the Azure Container Registry (globally unique, alphanumeric, 5-50 chars)."
}

variable "monitoring_retention_days" {
  type        = number
  description = "Log retention period in days for the Log Analytics Workspace."
  default     = 30
}

variable "alert_email" {
  type        = string
  description = "Email address for critical operational alerts."
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID for Defender for Cloud and Policy scope."
}

variable "security_contact_email" {
  type        = string
  description = "Email address for Microsoft Defender for Cloud security alerts."
}

variable "allowed_locations" {
  type        = list(string)
  description = "Allowed Azure regions enforced by Azure Policy."
  default     = ["uksouth", "ukwest"]
}

variable "ops_principal_id" {
  type        = string
  description = "Object ID of the ops Azure AD group for Contributor RBAC. Set null to skip."
  default     = null
}
