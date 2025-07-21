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
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "test-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  name                 = "test-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
 resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name
 
   ip_configuration {
     name                          = "internal"
     subnet_id                     = azurerm_subnet.subnet.id
     private_ip_address_allocation = "Dynamic"
   }
}
resource "azurerm_linux_virtual_machine" "vm_v2" {
   name                            = "copilot-test-vm-v2"
   location                        = azurerm_resource_group.rg.location
   resource_group_name             = azurerm_resource_group.rg.name
   size                            = "Standard_B1s"
   #network_interface_ids           = [azurerm_network_interface.nic_v2.id]
   network_interface_ids           = [azurerm_network_interface.nic.id]
   admin_username                  = "azureuser"
   disable_password_authentication = true
 
   admin_ssh_key {
     username   = "azureuser"
     public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRJaB9f+o1bWUQFfigorqJVfcLNKX2Ox29MtvqyPgMz4D/WuSpa09nIbgp195vuqLbHiGG0gV2WNQab1MOLbI8xSm9wLNyX0Srm4+jwWXylHpjflm3L1QnceQANnt2LVqr7h2mSMubytDxKhImOnSXejgylyVp+nFV0624lHuyJXDNHZl+RXC0giEE1Iujz3Mu2lyZ1DkWAYzAbvvZfu8jOVuSk8hdpjZn6k0jvMkBGbCNxyg18SM/TSgx5X5Mwszjbx2dU1tNpXfW87XcvRn9zVE7Asw196YoZHx2yRadEf1KCv+vJxW/6Pwu1V7Uqg4k2t58rJ46217l39ZlKUJ9 preethi@SandboxHost-638883515602013682"
   }
 
   source_image_reference {
     publisher = "Canonical"
     offer     = "UbuntuServer"
     sku       = "18.04-LTS"
     version   = "latest"
   }
 
   os_disk {
     name                 = "copilot-osdisk-v2"
     caching              = "ReadWrite"
     storage_account_type = "Standard_LRS"
}
}

