############################
## Virtual Networks
############################

resource "azurerm_virtual_network" "hub" {
  name                = "${var.name_prefix}-hub-vnet"
  address_space       = [var.hub_address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_virtual_network" "app_spoke" {
  name                = "${var.name_prefix}-app-spoke"
  address_space       = [var.app_spoke_address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_virtual_network" "data_spoke" {
  name                = "${var.name_prefix}-data-spoke"
  address_space       = [var.data_spoke_address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

############################
## Subnets — Hub
############################

resource "azurerm_subnet" "hub_firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_firewall_subnet_prefix]
}

resource "azurerm_subnet" "hub_bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_bastion_subnet_prefix]
}

resource "azurerm_subnet" "hub_gateway" {
  count                = var.create_vpn_gateway ? 1 : 0
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_gateway_subnet_prefix]
}

############################
## Subnets — App Spoke
############################

resource "azurerm_subnet" "app_aks" {
  name                 = "aks-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.app_spoke.name
  address_prefixes     = [var.app_aks_subnet_prefix]
}

resource "azurerm_subnet" "app_service" {
  count                = var.create_app_service ? 1 : 0
  name                 = "appservice-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.app_spoke.name
  address_prefixes     = [var.app_service_subnet_prefix]

  delegation {
    name = "appservice-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

############################
## Subnets — Data Spoke
############################

resource "azurerm_subnet" "data_sql" {
  name                 = "sql-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.data_spoke.name
  address_prefixes     = [var.data_sql_subnet_prefix]
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage", "Microsoft.KeyVault"]
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "private-endpoints"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.data_spoke.name
  address_prefixes     = [var.private_endpoints_subnet_prefix]
}

############################
## Hub <-> Spoke VNet Peering (within region)
############################

resource "azurerm_virtual_network_peering" "hub_to_app" {
  name                         = "${var.name_prefix}-hub-to-app"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.hub.name
  remote_virtual_network_id    = azurerm_virtual_network.app_spoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = var.create_vpn_gateway
}

resource "azurerm_virtual_network_peering" "app_to_hub" {
  name                         = "${var.name_prefix}-app-to-hub"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.app_spoke.name
  remote_virtual_network_id    = azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = var.create_vpn_gateway
}

resource "azurerm_virtual_network_peering" "hub_to_data" {
  name                         = "${var.name_prefix}-hub-to-data"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.hub.name
  remote_virtual_network_id    = azurerm_virtual_network.data_spoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = var.create_vpn_gateway
}

resource "azurerm_virtual_network_peering" "data_to_hub" {
  name                         = "${var.name_prefix}-data-to-hub"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.data_spoke.name
  remote_virtual_network_id    = azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = var.create_vpn_gateway
}
