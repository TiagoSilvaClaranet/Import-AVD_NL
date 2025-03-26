locals {
  resourceGroupName = split("/", var.parentResourceId)[4]
}

data "azurerm_resource_group" "resourceGroup" {
    name = local.resourceGroupName
}

resource "azurerm_monitor_scheduled_query_rules_alert" "serviceDownAlert-10x5" {
  name                = "${var.nlcNumber}-serviceDownAlert-10x5"
  location            = data.azurerm_resource_group.resourceGroup.location
  resource_group_name = data.azurerm_resource_group.resourceGroup.name

  action {
    action_group           = ["${var.actionGroupResourceId}"]
  }
  data_source_id = var.logAnalyticsWorkspaceResourceId10x5
  description    = "A service that should be running is down"
  enabled        = true
  query       = <<QUERY
  let Computers = InsightsMetrics
  | where TimeGenerated > ago(15m)
  | where Name == "Heartbeat"
  | where Computer !has "-SH"
  | summarize by Computer
  | project Computer;

  ConfigurationChange
  | where Computer in (Computers)
  | where TimeGenerated > ago(15m)
  | where ConfigChangeType == "WindowsServices" and SvcChangeType == "State"
  | where SvcPreviousState == "Running" and SvcState == "Stopped" and SvcDisplayName != "Software Protection" and SvcDisplayName != "IaasVmProvider" and SvcDisplayName != "Windows Modules Installer" and SvcDisplayName != "Remote Registry"
  | where SvcStartupType == "Auto"
  QUERY
  severity    = 0
  frequency   = 15
  time_window = 15
  trigger {
    operator  = "GreaterThan"
    threshold = 0
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert" "serviceDownAlert-24x7" {
  name                = "${var.nlcNumber}-serviceDownAlert-24x7"
  location            = data.azurerm_resource_group.resourceGroup.location
  resource_group_name = data.azurerm_resource_group.resourceGroup.name

  action {
    action_group           = ["${var.actionGroupResourceId}", "${var.pagerDutyActionGroupResourceId}"]
  }
  data_source_id = var.logAnalyticsWorkspaceResourceId24x7
  description    = "A service that should be running is down"
  enabled        = true
  query       = <<QUERY
  let Computers = InsightsMetrics
  | where TimeGenerated > ago(15m)
  | where Name == "Heartbeat"
  | where Computer !has "-SH"
  | summarize by Computer
  | project Computer;

  ConfigurationChange
  | where Computer in (Computers)
  | where TimeGenerated > ago(15m)
  | where ConfigChangeType == "WindowsServices" and SvcChangeType == "State"
  | where SvcPreviousState == "Running" and SvcState == "Stopped" and SvcDisplayName != "Software Protection" and SvcDisplayName != "IaasVmProvider" and SvcDisplayName != "Windows Modules Installer" and SvcDisplayName != "Remote Registry"
  | where SvcStartupType == "Auto"
  QUERY
  severity    = 0
  frequency   = 15
  time_window = 15
  trigger {
    operator  = "GreaterThan"
    threshold = 0
  }
}