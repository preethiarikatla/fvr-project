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
  egress_nic_names = {
    for k, nic in data.azurerm_network_interface.fetched_nics : k => nic.name
  }

  egress_nic_locations = {
    for k, nic in data.azurerm_network_interface.fetched_nics : k => nic.location
  }

  egress_ipconfig_names = {
    for k, nic in data.azurerm_network_interface.fetched_nics : k => nic.ip_configuration[0].name
  }

  egress_subnet_ids = {
    for k, nic in data.azurerm_network_interface.fetched_nics : k => nic.ip_configuration[0].subnet_id
  }

}
# ✅ Fetch remote state from Terraform Cloud
data "terraform_remote_state" "child" {
  backend = "remote"
  config = {
    organization = "tesy"
    workspaces = {
      name = "pre"
    }
  }
}

# ✅ Extract NIC IDs as map from child outputs
locals {
  nic_ids = data.terraform_remote_state.child.outputs.nic_ids
}

# ✅ Use those NIC IDs to fetch full NIC metadata
data "azurerm_network_interface" "fetched_nics" {
  for_each = local.nic_ids
  id       = each.value
}

