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

data "terraform_remote_state" "child" {
  backend = "remote"

  config = {
    organization = "tesy"        
    workspaces = {
      name = "pree"                    
    }
  }
}


# Set local for NIC metadata
locals {
  nic_metadata = data.terraform_remote_state.child.outputs.nic_metadata
}

# Fetch NICs with name + RG
data "azurerm_network_interface" "fetched_nics" {
  for_each = local.nic_metadata

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}
# Step 4: Pass NIC info to child patch module
module "patch_nics" {
  source              = "../child"
  resource_group_name = "pree"
  location            = "East US"

  egress_nic_names = {
    for k, nic in data.azurerm_network_interface.fetched_nics : k => nic.name
  }

  egress_nic_locations = {
    for k, nic in data.azurerm_network_interface.fetched_nics : k => nic.location
  }

  egress_ipconfig_names = {
    for k, nic in data.azurerm_network_interface.fetched_nics : k => nic.ip_configuration[0].name
  }
}
