############################
## Naming & Location
############################

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

############################
## Network Address Spaces
############################

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

############################
## Hub Subnets
############################

variable "hub_firewall_subnet_prefix" {
  type        = string
  description = "Subnet prefix for AzureFirewallSubnet in the hub. Must be at least /26."
}

variable "hub_bastion_subnet_prefix" {
  type        = string
  description = "Subnet prefix for AzureBastionSubnet in the hub. Must be at least /26."
}

variable "hub_gateway_subnet_prefix" {
  type        = string
  description = "Subnet prefix for GatewaySubnet in the hub. Must be at least /27. Required when create_vpn_gateway = true."
  default     = ""
}

############################
## App Spoke Subnets
############################

variable "app_aks_subnet_prefix" {
  type        = string
  description = "Subnet prefix for AKS nodes in the app spoke."
}

variable "app_service_subnet_prefix" {
  type        = string
  description = "Subnet prefix for App Service VNet integration in the app spoke. Required when create_app_service = true."
  default     = ""
}

############################
## Data Spoke Subnets
############################

variable "data_sql_subnet_prefix" {
  type        = string
  description = "Subnet prefix for SQL in the data spoke."
}

variable "private_endpoints_subnet_prefix" {
  type        = string
  description = "Subnet prefix for private endpoints in the data spoke."
}

############################
## AKS
############################

variable "aks_node_count" {
  type        = number
  description = "Node count for the AKS cluster."
}

variable "aks_node_size" {
  type        = string
  description = "VM size for AKS nodes."
}

variable "aks_service_cidr" {
  type        = string
  description = "Service CIDR for the AKS cluster. Must not overlap with any VNet address spaces."
  default     = "10.240.0.0/24"
}

variable "aks_dns_service_ip" {
  type        = string
  description = "DNS service IP for AKS. Must be within aks_service_cidr."
  default     = "10.240.0.10"
}

variable "acr_id" {
  type        = string
  description = "Resource ID of the Azure Container Registry. If set, grants AKS kubelet identity AcrPull access."
  default     = null
}

############################
## Storage
############################

variable "storage_account_name" {
  type        = string
  description = "Storage account name (3-24 lowercase alphanumeric, globally unique)."
}

############################
## Optional Services
############################

variable "create_vpn_gateway" {
  type        = bool
  description = "Whether to deploy an Azure VPN Gateway in this region."
  default     = false
}

variable "create_app_service" {
  type        = bool
  description = "Whether to deploy an App Service (with VNet integration) in this region."
  default     = false
}

variable "app_service_sku_name" {
  type        = string
  description = "SKU for the App Service Plan. Must be P1v3 or higher for VNet integration."
  default     = "P1v3"
}

variable "create_key_vault" {
  type        = bool
  description = "Whether to create a Key Vault in this region (enabled for secondary region)."
  default     = false
}

############################
## Identity & Security
############################

variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID for Key Vault and AKS AAD integration."
}

############################
## Monitoring
############################

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics Workspace ID for diagnostic settings. Set null to skip diagnostics."
  default     = null
}

############################
## Tags
############################

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources in this regional stack."
  default     = {}
}
