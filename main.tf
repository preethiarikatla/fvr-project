terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.19.0"  # Ensuring compatibility with the installed version
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
# Peering from vnet-source to vnet-destination
resource "azurerm_virtual_network_peering" "vnet1_to_vnet2" {
  name                      = "peer-vnet1-to-vnet2-gopi"  # Unique name
  resource_group_name       = azurerm_resource_group.example.name
  virtual_network_name      = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# Peering from vnet-destination to vnet-source
resource "azurerm_virtual_network_peering" "vnet2_to_vnet1" {
  name                      = "peer-vnet2-to-vnet1-gopi"  # Different name from above
  resource_group_name       = azurerm_resource_group.example.name
  virtual_network_name      = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}




