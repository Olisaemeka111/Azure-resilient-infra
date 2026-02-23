terraform {
  required_version = ">= 1.4"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110"
    }
  }
}

provider "azurerm" {
  features {}
}

############################
## Resource Groups
############################

resource "azurerm_resource_group" "primary" {
  name     = var.primary_rg_name
  location = var.primary_location
  tags     = var.tags
}

resource "azurerm_resource_group" "secondary" {
  name     = var.secondary_rg_name
  location = var.secondary_location
  tags     = var.tags
}

############################
## Regional Stacks (Primary & Secondary)
############################

module "primary_region" {
  source = "../region_stack"

  name_prefix               = "${var.name_prefix}-pri"
  location                  = azurerm_resource_group.primary.location
  resource_group_name       = azurerm_resource_group.primary.name
  hub_address_space         = var.primary_hub_address_space
  app_spoke_address_space   = var.primary_app_spoke_address_space
  data_spoke_address_space  = var.primary_data_spoke_address_space
  hub_firewall_subnet_prefix = var.primary_hub_firewall_subnet_prefix
  app_aks_subnet_prefix      = var.primary_app_aks_subnet_prefix
  data_sql_subnet_prefix     = var.primary_data_sql_subnet_prefix

  aks_node_count       = var.aks_primary_node_count
  aks_node_size        = var.aks_node_size
  storage_account_name = "${var.storage_account_name_prefix}pri"

  create_key_vault = false
  tenant_id        = var.tenant_id
  tags             = merge(var.tags, { role = "primary" })
}

module "secondary_region" {
  source = "../region_stack"

  name_prefix               = "${var.name_prefix}-sec"
  location                  = azurerm_resource_group.secondary.location
  resource_group_name       = azurerm_resource_group.secondary.name
  hub_address_space         = var.secondary_hub_address_space
  app_spoke_address_space   = var.secondary_app_spoke_address_space
  data_spoke_address_space  = var.secondary_data_spoke_address_space
  hub_firewall_subnet_prefix = var.secondary_hub_firewall_subnet_prefix
  app_aks_subnet_prefix      = var.secondary_app_aks_subnet_prefix
  data_sql_subnet_prefix     = var.secondary_data_sql_subnet_prefix

  aks_node_count       = var.aks_secondary_node_count
  aks_node_size        = var.aks_node_size
  storage_account_name = "${var.storage_account_name_prefix}sec"

  create_key_vault = true
  tenant_id        = var.tenant_id
  tags             = merge(var.tags, { role = "secondary" })
}

############################
## Hub VNets (Primary & Secondary)
############################

resource "azurerm_virtual_network" "hub_primary" {
  name                = "${var.name_prefix}-hub-vnet-primary"
  address_space       = [var.primary_hub_address_space]
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name
  tags                = var.tags
}

resource "azurerm_virtual_network" "hub_secondary" {
  name                = "${var.name_prefix}-hub-vnet-secondary"
  address_space       = [var.secondary_hub_address_space]
  location            = azurerm_resource_group.secondary.location
  resource_group_name = azurerm_resource_group.secondary.name
  tags                = var.tags
}

############################
## Spoke VNets: App + Data
############################

resource "azurerm_virtual_network" "app_spoke_primary" {
  name                = "${var.name_prefix}-app-spoke-primary"
  address_space       = [var.primary_app_spoke_address_space]
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name
  tags                = var.tags
}

resource "azurerm_virtual_network" "data_spoke_primary" {
  name                = "${var.name_prefix}-data-spoke-primary"
  address_space       = [var.primary_data_spoke_address_space]
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name
  tags                = var.tags
}

resource "azurerm_virtual_network" "app_spoke_secondary" {
  name                = "${var.name_prefix}-app-spoke-secondary"
  address_space       = [var.secondary_app_spoke_address_space]
  location            = azurerm_resource_group.secondary.location
  resource_group_name = azurerm_resource_group.secondary.name
  tags                = var.tags
}

resource "azurerm_virtual_network" "data_spoke_secondary" {
  name                = "${var.name_prefix}-data-spoke-secondary"
  address_space       = [var.secondary_data_spoke_address_space]
  location            = azurerm_resource_group.secondary.location
  resource_group_name = azurerm_resource_group.secondary.name
  tags                = var.tags
}

############################
## Subnets (simplified)
############################

resource "azurerm_subnet" "hub_firewall_primary" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.primary.name
  virtual_network_name = azurerm_virtual_network.hub_primary.name
  address_prefixes     = [var.primary_hub_firewall_subnet_prefix]
}

resource "azurerm_subnet" "hub_firewall_secondary" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.secondary.name
  virtual_network_name = azurerm_virtual_network.hub_secondary.name
  address_prefixes     = [var.secondary_hub_firewall_subnet_prefix]
}

resource "azurerm_subnet" "app_primary_aks" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.primary.name
  virtual_network_name = azurerm_virtual_network.app_spoke_primary.name
  address_prefixes     = [var.primary_app_aks_subnet_prefix]
}

resource "azurerm_subnet" "app_secondary_aks" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.secondary.name
  virtual_network_name = azurerm_virtual_network.app_spoke_secondary.name
  address_prefixes     = [var.secondary_app_aks_subnet_prefix]
}

resource "azurerm_subnet" "data_primary_sql" {
  name                 = "sql-subnet"
  resource_group_name  = azurerm_resource_group.primary.name
  virtual_network_name = azurerm_virtual_network.data_spoke_primary.name
  address_prefixes     = [var.primary_data_sql_subnet_prefix]
}

resource "azurerm_subnet" "data_secondary_sql" {
  name                 = "sql-subnet"
  resource_group_name  = azurerm_resource_group.secondary.name
  virtual_network_name = azurerm_virtual_network.data_spoke_secondary.name
  address_prefixes     = [var.secondary_data_sql_subnet_prefix]
}

############################
## Azure Firewall (Primary & Secondary)
############################

resource "azurerm_public_ip" "firewall_primary" {
  name                = "${var.name_prefix}-fw-pip-primary"
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_public_ip" "firewall_secondary" {
  name                = "${var.name_prefix}-fw-pip-secondary"
  location            = azurerm_resource_group.secondary.location
  resource_group_name = azurerm_resource_group.secondary.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_firewall" "primary" {
  name                = "${var.name_prefix}-afw-primary"
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.hub_firewall_primary.id
    public_ip_address_id = azurerm_public_ip.firewall_primary.id
  }

  tags = var.tags
}

resource "azurerm_firewall" "secondary" {
  name                = "${var.name_prefix}-afw-secondary"
  location            = azurerm_resource_group.secondary.location
  resource_group_name = azurerm_resource_group.secondary.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.hub_firewall_secondary.id
    public_ip_address_id = azurerm_public_ip.firewall_secondary.id
  }

  tags = var.tags
}

############################
## AKS Clusters (Primary prod, Secondary standby)
############################

resource "azurerm_kubernetes_cluster" "aks_primary" {
  name                = "${var.name_prefix}-aks-primary"
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name
  dns_prefix          = "${var.name_prefix}-aks-primary"

  default_node_pool {
    name           = "system"
    node_count     = var.aks_primary_node_count
    vm_size        = var.aks_node_size
    vnet_subnet_id = azurerm_subnet.app_primary_aks.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    dns_service_ip    = "10.2.0.10"
    service_cidr      = "10.2.0.0/24"
    docker_bridge_cidr = "172.17.0.1/16"
  }

  tags = merge(var.tags, { "role" = "primary-prod" })
}

resource "azurerm_kubernetes_cluster" "aks_secondary" {
  name                = "${var.name_prefix}-aks-secondary"
  location            = azurerm_resource_group.secondary.location
  resource_group_name = azurerm_resource_group.secondary.name
  dns_prefix          = "${var.name_prefix}-aks-secondary"

  default_node_pool {
    name           = "system"
    node_count     = var.aks_secondary_node_count
    vm_size        = var.aks_node_size
    vnet_subnet_id = azurerm_subnet.app_secondary_aks.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    dns_service_ip    = "10.3.0.10"
    service_cidr      = "10.3.0.0/24"
    docker_bridge_cidr = "172.18.0.1/16"
  }

  tags = merge(var.tags, { "role" = "secondary-standby" })
}

############################
## Azure SQL: Primary + Geo-Replica
############################

resource "azurerm_mssql_server" "primary" {
  name                         = "${var.name_prefix}-sql-primary"
  resource_group_name          = azurerm_resource_group.primary.name
  location                     = azurerm_resource_group.primary.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
  minimum_tls_version          = "1.2"
  tags                         = var.tags
}

resource "azurerm_mssql_server" "secondary" {
  name                         = "${var.name_prefix}-sql-secondary"
  resource_group_name          = azurerm_resource_group.secondary.name
  location                     = azurerm_resource_group.secondary.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
  minimum_tls_version          = "1.2"
  tags                         = var.tags
}

resource "azurerm_mssql_database" "primary" {
  name           = "${var.name_prefix}-sqldb"
  server_id      = azurerm_mssql_server.primary.id
  sku_name       = var.sql_sku_name
  zone_redundant = true
  tags           = var.tags
}

resource "azurerm_mssql_database" "secondary_geo_replica" {
  name           = azurerm_mssql_database.primary.name
  server_id      = azurerm_mssql_server.secondary.id
  create_mode    = "Secondary"
  source_database_id = azurerm_mssql_database.primary.id
  sku_name       = var.sql_sku_name
  zone_redundant = false
  tags           = var.tags
}

############################
## Storage Accounts (GRS + Replica)
############################

resource "azurerm_storage_account" "primary" {
  name                     = "${var.storage_account_name_prefix}pri"
  resource_group_name      = azurerm_resource_group.primary.name
  location                 = azurerm_resource_group.primary.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  allow_blob_public_access = false
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

resource "azurerm_storage_account" "secondary" {
  name                     = "${var.storage_account_name_prefix}sec"
  resource_group_name      = azurerm_resource_group.secondary.name
  location                 = azurerm_resource_group.secondary.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  allow_blob_public_access = false
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

############################
## Key Vault (Secondary Replica)
############################

resource "azurerm_key_vault" "secondary" {
  name                        = "${var.name_prefix}-kv-secondary"
  location                    = azurerm_resource_group.secondary.location
  resource_group_name         = azurerm_resource_group.secondary.name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  enabled_for_deployment      = true
  enabled_for_disk_encryption = true
  enabled_for_template_deployment = true

  tags = var.tags
}

############################
## Azure Front Door (Global)
############################

resource "azurerm_cdn_frontdoor_profile" "this" {
  name                = "${var.name_prefix}-afd-profile"
  resource_group_name = azurerm_resource_group.primary.name
  sku_name            = "Standard_AzureFrontDoor"
  tags                = var.tags
}

resource "azurerm_cdn_frontdoor_endpoint" "this" {
  name                     = "${var.name_prefix}-afd-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
}

############################
## Outputs
############################

output "primary_rg_name" {
  value = azurerm_resource_group.primary.name
}

output "secondary_rg_name" {
  value = azurerm_resource_group.secondary.name
}

output "aks_primary_name" {
  value = module.primary_region.aks_name
}

output "aks_secondary_name" {
  value = module.secondary_region.aks_name
}

output "sql_primary_fqdn" {
  value = azurerm_mssql_server.primary.fully_qualified_domain_name
}

output "afd_endpoint_hostname" {
  value = azurerm_cdn_frontdoor_endpoint.this.host_name
}

