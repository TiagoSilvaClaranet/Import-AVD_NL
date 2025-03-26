resource azurerm_route_table route_table {
  for_each                      = var.route_tables
  name                          = each.key
  location                      = var.location
  resource_group_name           = var.resource-group-name
  disable_bgp_route_propagation = each.value.disable_bgp
  tags                          = var.tags
  lifecycle {
    ignore_changes = [tags["creation_timestamp"]]
  }
}

resource azurerm_route route {
  for_each               = var.routes
  name                   = each.key
  route_table_name       = each.value.table_name
  resource_group_name    = var.resource-group-name
  address_prefix         = each.value.address
  next_hop_type          = each.value.hop_type
  next_hop_in_ip_address = each.value.hop_type == "VirtualAppliance" ? each.value.hop_ip : null
  depends_on             = [azurerm_route_table.route_table]
}

