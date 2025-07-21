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
  vm_name           = "copilot-test-vm-v2"
  nic_name          = "conic"
  public_ip_name    = "gigy"
}

