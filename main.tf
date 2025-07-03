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
  name     = "rg-ignore-test"
  location = "East US"
}

resource "azurerm_app_configuration" "example" {
  name                = "example-appconfig"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "standard"

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "dev"
  }

lifecycle {
  ignore_changes = [
   name,
   tags.environment
  ]
}
}

