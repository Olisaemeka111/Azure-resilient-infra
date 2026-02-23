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

resource "azurerm_subnet" "hub_firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_firewall_subnet_prefix]
}

resource "azurerm_subnet" "app_aks" {
  name                 = "aks-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.app_spoke.name
  address_prefixes     = [var.app_aks_subnet_prefix]
}

resource "azurerm_subnet" "data_sql" {
  name                 = "sql-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.data_spoke.name
  address_prefixes     = [var.data_sql_subnet_prefix]
}

resource "azurerm_public_ip" "firewall" {
  name                = "${var.name_prefix}-fw-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_firewall" "this" {
  name                = "${var.name_prefix}-afw"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.hub_firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }

  tags = var.tags
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.name_prefix}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.name_prefix}-aks"

  default_node_pool {
    name           = "system"
    node_count     = var.aks_node_count
    vm_size        = var.aks_node_size
    vnet_subnet_id = azurerm_subnet.app_aks.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    dns_service_ip    = "10.10.0.10"
    service_cidr      = "10.10.0.0/24"
    docker_bridge_cidr = "172.20.0.1/16"
  }

  tags = var.tags
}

resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  allow_blob_public_access = false
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

resource "azurerm_key_vault" "this" {
  count                       = var.create_key_vault ? 1 : 0
  name                        = "${var.name_prefix}-kv"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  enabled_for_deployment      = true
  enabled_for_disk_encryption = true
  enabled_for_template_deployment = true

  tags = var.tags
}

output "hub_vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "app_spoke_vnet_id" {
  value = azurerm_virtual_network.app_spoke.id
}

output "data_spoke_vnet_id" {
  value = azurerm_virtual_network.data_spoke.id
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "storage_account_name" {
  value = azurerm_storage_account.this.name
}

output "key_vault_id" {
  value = one(azurerm_key_vault.this[*].id)
}

