output "nic_metadata" {
  value = {
    for k, nic in azurerm_network_interface.nic :
    k => {
      name                = azurerm_network_interface.nic.name
      resource_group_name = azurerm_network_interface.nic.resource_group_name
    }
  }
}
