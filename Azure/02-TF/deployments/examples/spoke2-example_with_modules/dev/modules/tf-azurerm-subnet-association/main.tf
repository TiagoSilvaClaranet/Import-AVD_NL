resource "azurerm_subnet_network_security_group_association" "nsg_subnet" {
  for_each                  = var.subnet_nsgs
  subnet_id                 = var.subnet_map[each.key]
  network_security_group_id = var.nsg_map[each.value]
}

resource "azurerm_subnet_route_table_association" "route_subnet" {
  for_each       = var.subnet_udrs
  subnet_id      = var.subnet_map[each.key]
  route_table_id = var.route_table_map[each.value]
}
