/*
Application Group diagnostics settings to be set:
- Management Activities
- Feed
- Errors
- Checkpoints
*/

resource "azurerm_monitor_diagnostic_setting" "avd-dag-diag" {
  count                      = var.enable_diagnostics == true ? 1 : 0
  name                       = "AVD - Diagnostics"
  #name                      = "diag-fd-${var.solution}${var.prefix}-avd"
  #target_resource_id        = azurerm_virtual_desktop_application_group.fd.id 
  target_resource_id         = azurerm_virtual_desktop_application_group.dag.id
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
}