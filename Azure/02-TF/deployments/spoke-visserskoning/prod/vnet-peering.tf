# Spoke to HUB vnet peering
resource "azurerm_virtual_network_peering" "peer-spoke1-to-hub" {
  name                      = "peer-${azurerm_virtual_network.spoke_vnet1.name}-to-${data.terraform_remote_state.hubstate.outputs.hub_vnet_name}"
  resource_group_name       = azurerm_resource_group.rg-spoke-visserskoning-network.name
  virtual_network_name      = azurerm_virtual_network.spoke_vnet1.name
  remote_virtual_network_id = data.terraform_remote_state.hubstate.outputs.hub_vnet_id
  #allow_virtual_network_access = true # (Default = true) Controls if the VMs in the remote virtual network can access VMs in the local virtual network
  allow_forwarded_traffic      = true # (Default = false) Controls if forwarded traffic from VMs in the remote virtual network is allowed.
  #allow_gateway_transit        = true # Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. Only use when GatewaySubnet is in place
  #use_remote_gateways          = true # (Default = false) Controls if remote gateways can be used on the local virtual network.
}

# HUB to Spoke vnet peering 
resource "azurerm_virtual_network_peering" "peer-hub-to-spoke1" {
  name                      = "peer-${data.terraform_remote_state.hubstate.outputs.hub_vnet_name}-to-${azurerm_virtual_network.spoke_vnet1.name}"
  resource_group_name       = data.terraform_remote_state.hubstate.outputs.hub_vnet_resource_group_name # Retrieve resource group name from remote state
  virtual_network_name      = data.terraform_remote_state.hubstate.outputs.hub_vnet_name                # Retrieve vnet name from remote state
  remote_virtual_network_id = azurerm_virtual_network.spoke_vnet1.id                                    # Retrieve vnet id from remote state
  #allow_virtual_network_access = true # (Default = true) Controls if the VMs in the remote virtual network can access VMs in the local virtual network
  #allow_forwarded_traffic      = true # (Default = false) Controls if forwarded traffic from VMs in the remote virtual network is allowed.
  #allow_gateway_transit        = true # Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. Only use when GatewaySubnet is in place
  #use_remote_gateways          = true # (Default = false) Controls if remote gateways can be used on the local virtual network.
}

