# Deploy Log Analytics Agent on VM
# Be sure to pass the Workspace ID and not the ID of the workspace itself!

resource "azurerm_virtual_machine_extension" "enable-sessionhost-law" {
  count                      = var.enable_diagnostics == true ? length(azurerm_windows_virtual_machine.avd-sessionhosts) : 0
  name                       = "sessionhost-LogAnalytics"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd-sessionhosts[count.index].id
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "MicrosoftMonitoringAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
	{
	    "workspaceId": "${var.log_analytics_workspace_id}"
	}
SETTINGS

  protected_settings = <<protectedsettings
  {
      "workspaceKey": "${var.log_analytics_workspace_key}"
  }
protectedsettings

}