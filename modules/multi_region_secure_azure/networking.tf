module "cross_region_peering" {
  source = "../cross_region_peering"

  name_prefix = var.name_prefix

  primary_rg_name       = azurerm_resource_group.primary.name
  primary_hub_vnet_name = module.primary_region.hub_vnet_name
  primary_hub_vnet_id   = module.primary_region.hub_vnet_id

  secondary_rg_name       = azurerm_resource_group.secondary.name
  secondary_hub_vnet_name = module.secondary_region.hub_vnet_name
  secondary_hub_vnet_id   = module.secondary_region.hub_vnet_id
}
