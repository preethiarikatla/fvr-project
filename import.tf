import {
  id = "/subscriptions/7e7e9b8c-d389-4d54-ae57-03a451e26d57/resourceGroups/rg-ignore-testt/providers/Microsoft.Network/virtualNetworks/vnet-source"
  to = azurerm_virtual_network_peering.vnet1_to_vnet2
}

import {
  id = "/subscriptions/7e7e9b8c-d389-4d54-ae57-03a451e26d57/resourceGroups/rg-ignore-testt/providers/Microsoft.Network/virtualNetworks/vnet-destination"
  to = azurerm_virtual_network_peering.vnet2_to_vnet1
}
