terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.19.0"
    }
  }
}
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-ignore-testt"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet-source"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "vnet-destination"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_virtual_network_peering" "vnet1_to_vnet2" {
  name                          = "peer-vnet1-to-vnet2-nan"
  resource_group_name           = azurerm_resource_group.example.name
  virtual_network_name          = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id     = azurerm_virtual_network.vnet2.id
  allow_virtual_network_access  = true
  allow_forwarded_traffic       = true
  allow_gateway_transit         = false
  use_remote_gateways           = false
}
resource "azurerm_virtual_network_peering" "vnet2_to_vnet1" {
  name                          = "peer-vnet1-to-vnet2-nan"
  resource_group_name           = azurerm_resource_group.example.name
  virtual_network_name          = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id     = azurerm_virtual_network.vnet1.id
  allow_virtual_network_access  = true
  allow_forwarded_traffic       = true
  allow_gateway_transit         = false
  use_remote_gateways           = false
}
resource "azurerm_virtual_network_peering" "vnet1_to_vnet2_new" {
  name                          = "peer-vnet1-to-vnet2-nani"
  resource_group_name           = azurerm_resource_group.example.name
  virtual_network_name          = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id     = azurerm_virtual_network.vnet2.id
  allow_virtual_network_access  = true
  allow_forwarded_traffic       = true
  allow_gateway_transit         = false
  use_remote_gateways           = false
}
resource "azurerm_virtual_network_peering" "vnet2_to_vnet1_new" {
  name                          = "peer-vnet1-to-vnet2-nani"
  resource_group_name           = azurerm_resource_group.example.name
  virtual_network_name          = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id     = azurerm_virtual_network.vnet1.id
  allow_virtual_network_access  = true
  allow_forwarded_traffic       = true
  allow_gateway_transit         = false
  use_remote_gateways           = false
}
resource "azurerm_network_security_group" "example" {
  name                = "nsg-after-peering"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  depends_on = [
    azurerm_virtual_network_peering.vnet1_to_vnet2,
    azurerm_virtual_network_peering.vnet2_to_vnet1
  ]
}
#hi
