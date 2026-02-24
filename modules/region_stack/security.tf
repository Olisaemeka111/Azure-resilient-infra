############################
## Azure Firewall
############################

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

############################
## Firewall Rules
############################

resource "azurerm_firewall_network_rule_collection" "aks_outbound" {
  name                = "${var.name_prefix}-aks-outbound"
  azure_firewall_name = azurerm_firewall.this.name
  resource_group_name = var.resource_group_name
  priority            = 100
  action              = "Allow"

  rule {
    name                  = "allow-dns"
    protocols             = ["UDP"]
    source_addresses      = [var.app_spoke_address_space]
    destination_addresses = ["*"]
    destination_ports     = ["53"]
  }

  rule {
    name                  = "allow-aks-control-plane"
    protocols             = ["TCP"]
    source_addresses      = [var.app_spoke_address_space]
    destination_addresses = ["AzureCloud"]
    destination_ports     = ["443", "9000", "1194"]
  }

  rule {
    name                  = "allow-ntp"
    protocols             = ["UDP"]
    source_addresses      = [var.app_spoke_address_space]
    destination_addresses = ["*"]
    destination_ports     = ["123"]
  }
}

resource "azurerm_firewall_application_rule_collection" "aks_required_fqdns" {
  name                = "${var.name_prefix}-aks-required-fqdns"
  azure_firewall_name = azurerm_firewall.this.name
  resource_group_name = var.resource_group_name
  priority            = 200
  action              = "Allow"

  rule {
    name             = "allow-mcr"
    source_addresses = [var.app_spoke_address_space]
    target_fqdns     = ["mcr.microsoft.com", "*.data.mcr.microsoft.com", "*.cdn.mscr.io"]
    protocol {
      port = "443"
      type = "Https"
    }
  }

  rule {
    name             = "allow-azure-services"
    source_addresses = [var.app_spoke_address_space]
    target_fqdns     = ["management.azure.com", "login.microsoftonline.com", "*.azmk8s.io"]
    protocol {
      port = "443"
      type = "Https"
    }
  }

  rule {
    name             = "allow-ubuntu-updates"
    source_addresses = [var.app_spoke_address_space]
    target_fqdns     = ["security.ubuntu.com", "azure.archive.ubuntu.com", "changelogs.ubuntu.com"]
    protocol {
      port = "80"
      type = "Http"
    }
  }
}
