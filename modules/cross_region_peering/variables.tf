variable "name_prefix" {
  type        = string
  description = "Prefix used for peering resource names."
}

variable "primary_rg_name" {
  type        = string
  description = "Resource group containing the primary hub VNet."
}

variable "primary_hub_vnet_name" {
  type        = string
  description = "Name of the primary hub VNet."
}

variable "primary_hub_vnet_id" {
  type        = string
  description = "Resource ID of the primary hub VNet."
}

variable "secondary_rg_name" {
  type        = string
  description = "Resource group containing the secondary hub VNet."
}

variable "secondary_hub_vnet_name" {
  type        = string
  description = "Name of the secondary hub VNet."
}

variable "secondary_hub_vnet_id" {
  type        = string
  description = "Resource ID of the secondary hub VNet."
}
