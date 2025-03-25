/*
Workspace diagnostics settings to be set:
- Management Activities
- Feed
- Errors
- Checkpoints
*/

resource "azurerm_monitor_diagnostic_setting" "avd-workspace-diag" {
  count                      = var.enable_diagnostics == true ? 1 : 0
  name                       = "AVD - Diagnostics"
  #name                       = "diag-workspace-${var.solution}${var.prefix}-avd"
  #target_resource_id        = azurerm_virtual_desktop_application_group.fd.id 
  target_resource_id         = azurerm_virtual_desktop_workspace.ws.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  
  log {
    category = "Checkpoint"
    enabled = "true"

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "Error"
    enabled = "true"

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "Management"
    enabled = "true"

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "Feed"
    enabled = "true"

    retention_policy {
      enabled = false
    }
  }
}