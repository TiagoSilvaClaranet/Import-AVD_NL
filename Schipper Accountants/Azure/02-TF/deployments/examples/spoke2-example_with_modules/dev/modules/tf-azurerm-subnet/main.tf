resource azurerm_subnet subnet {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = var.resource-group-name
  virtual_network_name = each.value.vnet
  # address_prefix       = each.value.cidr
  address_prefixes  = split(",", each.value.cidr)
  service_endpoints = each.value.service_endpoints
}
