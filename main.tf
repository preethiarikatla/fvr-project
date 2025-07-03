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
  name     = "rg-ignore-test1"
  location = "East US"
}

resource "azurerm_application_gateway" "example" {
  name                = "example-appgw"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  frontend_port {
    name = "frontendPort1"
    port = 80
  }

  http_listener {
    name                           = "listener1"
    frontend_ip_configuration_name = "frontendConfig1"
    frontend_port_name             = "frontendPort1"
    protocol                       = "Http"
  }

  lifecycle {
    ignore_changes = [
      name,
      http_listener[0].name
    ]
  }
}

