resource "azurerm_virtual_network_peering" "vnet_peer" {
  for_each = lookup(var.peerings, var.virtual-network, {})

  name = "peer-${var.virtual-network}-to-${each.key}"
  resource_group_name          = var.resource-group-name
  virtual_network_name         = var.virtual-network

  remote_virtual_network_id    = each.value["remote-virtual-network-id"]
  allow_virtual_network_access = each.value["allow-virtual-network-access"]
  allow_forwarded_traffic      = each.value["allow-forwarded-traffic"]
  allow_gateway_transit        = each.value["allow-gateway-transit"]
  use_remote_gateways          = each.value["use-remote-gateways"]
}
