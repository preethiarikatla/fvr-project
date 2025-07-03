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

resource "azurerm_storage_account" "example" {
  name                     = "ignoreteststorage123"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "test"
  }

  custom_domain {
    name          = "www.example.com"
    use_subdomain = false
  }

  lifecycle {
    ignore_changes = [
      tags,                  # top-level attribute
      custom_domain[0].name  # nested block
    ]
  }
}
