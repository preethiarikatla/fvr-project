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
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-cosmos-recreate"
  location = "East US"
}

resource "azurerm_cosmosdb_account" "cosmos" {
  name                = "cosmos-recreate-test"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  consistency_policy {
    consistency_level = "Session"
  }
  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }
  throughput = 400  # This is ForceNew
}

