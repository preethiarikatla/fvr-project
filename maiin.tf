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
