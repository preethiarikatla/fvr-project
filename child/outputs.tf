output "nic_metadata" {
  value = {
    for k, nic in azurerm_network_interface.nic :
    k => {
      name                = nic.name
      resource_group_name = nic.resource_group_name
    }
  }
}
