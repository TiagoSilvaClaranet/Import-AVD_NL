locals {
  # flatten ensures that this local value is a flat list of objects, rather
  # than a list of lists of objects.
  flat_nsgs = flatten([
    for nsg, rules in var.nsgs : [
      for rule_name, rule in rules : {
      nsg_name = nsg
      rule_name = rule_name
      priority                   = rule.priority
      direction                  = rule.direction
      access                     = rule.access
      protocol                   = rule.protocol
      source_port_ranges         = split(",", replace(rule.source_port_ranges, "*", "0-65535"))
      destination_port_ranges    = split(",", replace(rule.destination_port_ranges, "*", "0-65535"))
      # source_port_ranges         = rule.source_port_ranges
      # destination_port_ranges    = rule.destination_port_ranges
      source_address_prefix      = rule.source_address_prefix
      destination_address_prefix = rule.destination_address_prefix
      description                = rule.description
      }
    ]
  ])
}

resource azurerm_network_security_group nsg {
  for_each            = var.nsgs
  name                = each.key
  location            = var.location
  resource_group_name = var.resource-group-name
  tags                = var.tags

    lifecycle {
    ignore_changes = [tags["creation_timestamp"]]
  }
}

resource azurerm_network_security_rule nsg_rule {
  for_each = {
    for rule in local.flat_nsgs : "${rule.nsg_name}.${rule.rule_name}" => rule
  }
  resource_group_name = var.resource-group-name
  network_security_group_name = each.value.nsg_name
  name                        = each.value.rule_name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_ranges          = each.value.source_port_ranges
  destination_port_ranges     = each.value.destination_port_ranges
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  description                 = each.value.description
  depends_on                  = [azurerm_network_security_group.nsg]
}
