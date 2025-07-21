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


# Step 4: Pass NIC info to child patch module
module "ubuntu_vm" {
  source              = "../child"
  resource_group_name = "pree"
  location            = "East US"

}
