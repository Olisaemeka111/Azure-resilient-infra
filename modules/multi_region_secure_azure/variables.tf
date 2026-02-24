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

variable "sql_failover_grace_minutes" {
  type        = number
  description = "Grace period in minutes before automatic SQL failover is triggered."
  default     = 60
}

############################
## Primary Region — New Subnets
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

############################
## Secondary Region — New Subnets
############################

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
## Container Registry
############################

variable "registry_name" {
  type        = string
  description = "Name of the Azure Container Registry (globally unique, alphanumeric, 5-50 chars)."
}

############################
## Monitoring
############################

variable "monitoring_retention_days" {
  type        = number
  description = "Log retention period in days for the Log Analytics Workspace."
  default     = 30
}

variable "alert_email" {
  type        = string
  description = "Email address for critical operational alerts."
}

############################
## Governance
############################

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
  description = "Object ID of the ops Azure AD group granted Contributor RBAC. Set null to skip."
  default     = null
}

############################
## Tags
############################

variable "tags" {
  type        = map(string)
  description = "Common tags applied to all resources."
  default     = {}
}

