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


module "ubuntu_vm" {
  source            = "../child"
  resource_group_name = "pree"
  location          = "East US"

  nic_name          = "conic"

}
data "terraform_remote_state" "transitgw" {
  backend = "remote"

  config = {
    organization = "tesy"        
    workspaces = {
      name = "pree"                    
    }
  }
}

# Fetch NICs
data "azurerm_network_interface" "fetched_nics" {
  for_each = data.terraform_remote_state.transitgw.outputs.nic_ids
  id       = each.value
}
