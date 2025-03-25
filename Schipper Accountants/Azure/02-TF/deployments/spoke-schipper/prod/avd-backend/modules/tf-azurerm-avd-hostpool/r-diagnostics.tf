/*
 Hostpool diagnostics settings to be set:
- Management Activities
- Feed
- Connections
- Errors
- Checkpoints
- HostRegistration
- AgentHealthStatus

Please note!
Even we do not use ConnectionGraphicsData diagnostics data we have to set it to 'enabled = false' because otherwise terrraform will set all diagnostics logging on every run
See https://github.com/hashicorp/terraform-provider-azurerm/issues/3572

*/

resource "azurerm_monitor_diagnostic_setting" "avd-hostpool-diag" {
  count                      = var.enable_diagnostics == true ? 1 : 0
  name                       = "AVD - Diagnostics"
  #name                       = "diag-hp-${var.solution}${var.prefix}-avd"
  target_resource_id         = azurerm_virtual_desktop_host_pool.avd-hostpool.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "Error"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "Checkpoint"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "Management"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "Connection"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "HostRegistration"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AgentHealthStatus"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "NetworkData"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "SessionHostManagement"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "ConnectionGraphicsData"
    enabled = false

    retention_policy {
      enabled = false
    }
  }


}