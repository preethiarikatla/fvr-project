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
  name     = "rg-test-peering"
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

# Peering from vnet-source to vnet-destination
resource "azurerm_virtual_network_peering" "vnet1_to_vnet2" {
  name                          = "peer-vnet1-to-vnet2-nani"
  resource_group_name           = azurerm_resource_group.example.name
  virtual_network_name          = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id     = azurerm_virtual_network.vnet2.id
  allow_virtual_network_access  = true
  allow_forwarded_traffic       = true
  allow_gateway_transit         = false
  use_remote_gateways           = false
}

resource "azurerm_public_ip" "pip" {
  name                = "pip-test"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  domain_name_label   = "mylabel-${random_id.suffix.hex}"  # Ensures uniqueness
}







