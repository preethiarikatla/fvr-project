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

# Step 1: Create resource group
resource "azurerm_resource_group" "rg" {
  name     = "pree"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "test-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "test-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

data "azurerm_network_interface" "existing_nic" {
  name                = "he119_z3"
  resource_group_name = azurerm_resource_group.rg.name
}

# Step 2: Fetch the manually created static public IP
data "azurerm_public_ip" "reserved_ip" {
  name                = "test1"
  resource_group_name = azurerm_resource_group.rg.name
}

# Step 3: Update the NIC to use static public IP
resource "azurerm_network_interface" "nic_update" {
  name                = data.azurerm_network_interface.existing_nic.name
  location            = "East US"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = data.azurerm_network_interface.existing_nic.ip_configuration[0].name
    subnet_id                     = data.azurerm_network_interface.existing_nic.ip_configuration[0].subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = data.azurerm_public_ip.reserved_ip.id
  }

  lifecycle {
    ignore_changes = [
      ip_configuration[0].private_ip_address_allocation
    ]
  }

  depends_on = [
    data.azurerm_network_interface.existing_nic
  ]
}
