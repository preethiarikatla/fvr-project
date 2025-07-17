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

resource "azurerm_resource_group" "rg" {
  name     = "vm-no-login-rg"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vm-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "vm-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "vm-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "test-vm"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  size                            = "Standard_B1s"
  network_interface_ids           = [azurerm_network_interface.nic.id]
  admin_username                  = "azureuser"
  disable_password_authentication = true

  # 👇 Required dummy key – no login needed
admin_ssh_key {
  username   = "azureuser"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5eCB7LvG5hP4g4L3NgGmYFevRzZvzwu+9o1b0dYcC9N3oHdRsmgDHcJbVf6Za1KjM2nM0k4XzvVeZB4AfRZoUZnHd8NhxY9z+j8PRFJ+5xJ9MEiVZTi9t+6cfOjWkQaF5Qv6KUPy0JmcEZ2AKu0tEpFzU2RQGubFDE3V9eUvmjZtNz test@example.com"
}

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "18.04.202403130"  # ⬅️ change to test replacement
  }

  os_disk {
    name                 = "test-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}
