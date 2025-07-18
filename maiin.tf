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

data "azurerm_public_ip" "reserved_ip" {
  name                = "gig"
  resource_group_name = azurerm_resource_group.rg.name
}
data "azurerm_network_interface" "vm_nic" {
  name                = "heip279_z3"
  resource_group_name = azurerm_resource_group.rg.name
}
data "azurerm_subnet" "vm_subnet" {
  name                 = azurerm_subnet.subnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
}
resource "azurerm_resource_group_template_deployment" "patch_nic_ip" {
  name                = "patch-nic"
  resource_group_name = azurerm_resource_group.rg.name
  deployment_mode     = "Incremental"

  template_content = jsonencode({
    "$schema" = "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#"
    "contentVersion" = "1.0.0.0"
    "resources" = [
      {
        "type" = "Microsoft.Network/networkInterfaces"
        "apiVersion" = "2023-09-01"
        "name" = data.azurerm_network_interface.vm_nic.name
        "location" = azurerm_resource_group.rg.location
        "properties" = {
          "ipConfigurations" = [
            {
              "name" = "ipconfig1"
              "properties" = {
                "privateIPAllocationMethod" = "Dynamic"
                "subnet" = {
                  "id" = data.azurerm_subnet.vm_subnet.id
                }
                "publicIPAddress" = {
                  "id" = data.azurerm_public_ip.reserved_ip.id
                }
              }
            }
          ]
        }
      }
    ]
  })

  parameters_content = jsonencode({})
  depends_on = [
    data.azurerm_network_interface.vm_nic,
    data.azurerm_public_ip.reserved_ip,
    data.azurerm_subnet.vm_subnet
  ]
}
