locals {
  # flatten ensures that this local value is a flat list of objects, rather
  # than a list of lists of objects.
  network_vnets = flatten([
    for vnet in var.vnets : {
        vnet_name   = vnet.name
        dns         = vnet.dns
        cidr        = vnet.cidr
        ddos_id     = vnet.ddos_id
    }
  ])
}

resource "azurerm_virtual_network" "virtual_network" {
  for_each = {
    for vnet in local.network_vnets : vnet.vnet_name => vnet
  }

  resource_group_name = var.resource-group-name
  name                = each.value.vnet_name
  address_space       = each.value.cidr
  location            = var.location
  tags                = var.tags
  dns_servers         = each.value.dns

  lifecycle {
    ignore_changes = [tags["creation_timestamp"]]
  }

  dynamic "ddos_protection_plan" {
    for_each = each.value.ddos_id == "" ? [] : [1]
    content {
      enable = true
      id     = each.value.ddos_id
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "vnet_diagnostics" {
  for_each                   = var.log-analytics-resource-id == "" ? {} : {
    for vnet in local.network_vnets : vnet.vnet_name => vnet
  }
  name                       = "Vnet-To-LogAnalytics"
  target_resource_id         = azurerm_virtual_network.virtual_network[each.key].id
  log_analytics_workspace_id = var.log-analytics-resource-id //even though the terraform arguement is workspace_id, you must provide a full resource ID.


  log {
    category = "VMProtectionAlerts"
    enabled  = true

    retention_policy {
      enabled = var.diagnostics-retention-policy
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = var.metrics-retention-policy
    }
  }
}
