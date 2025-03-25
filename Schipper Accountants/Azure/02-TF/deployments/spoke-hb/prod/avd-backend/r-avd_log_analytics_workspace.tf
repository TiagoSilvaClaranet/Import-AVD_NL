# Create a dedicated Log Analytics Workspace for AVD Logging and Monitoring

# Create a random number to make LAW unique
resource "random_integer" "random" {
  min = 1
  max = 9999

}

# Create the Log analytics workspace using the default AVD resource group
resource "azurerm_log_analytics_workspace" "laws-avd" {
  #name                = "${var.laws_name-prefix}-${random_integer.random.result}"
  #name                = "avdlawtoberenamed-${random_integer.random.result}"
  #name                = "${var.nlcnumber}-log-avd-weu-${var.resourcesuffix}"
  name                = "${var.nlcnumber}-log-avd-weu-${random_integer.random.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

###################################
# Performance Counter Datasources #
###################################

resource "azurerm_log_analytics_datasource_windows_performance_counter" "laws-avd_perfcounter_001" {
  name                = "laws-avd_perfcounter_001"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  object_name         = "LogicalDisk"
  instance_name       = "C:"
  counter_name        = "% Free Space"
  interval_seconds    = 60
}
resource "azurerm_log_analytics_datasource_windows_performance_counter" "laws-avd_perfcounter_002" {
  name                = "laws-avd_perfcounter_002"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  object_name         = "LogicalDisk"
  instance_name       = "C:"
  counter_name        = "Avg. Disk Queue Length"
  interval_seconds    = 30
}
resource "azurerm_log_analytics_datasource_windows_performance_counter" "laws-avd_perfcounter_003" {
  name                = "laws-avd_perfcounter_003"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  object_name         = "LogicalDisk"
  instance_name       = "C:"
  counter_name        = "Avg. Disk sec/Transfer"
  interval_seconds    = 60
}
resource "azurerm_log_analytics_datasource_windows_performance_counter" "laws-avd_perfcounter_004" {
  name                = "laws-avd_perfcounter_004"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  object_name         = "LogicalDisk"
  instance_name       = "C:"
  counter_name        = "Current Disk Queue Length"
  interval_seconds    = 30
}
resource "azurerm_log_analytics_datasource_windows_performance_counter" "laws-avd_perfcounter_005" {
  name                = "laws-avd_perfcounter_005"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  object_name         = "Memory"
  instance_name       = "*"
  counter_name        = "Available Mbytes"
  interval_seconds    = 30
}
resource "azurerm_log_analytics_datasource_windows_performance_counter" "laws-avd_perfcounter_006" {
  name                = "laws-avd_perfcounter_006"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  object_name         = "Memory"
  instance_name       = "*"
  counter_name        = "Page Faults/sec"
  interval_seconds    = 30
}
resource "azurerm_log_analytics_datasource_windows_performance_counter" "laws-avd_perfcounter_007" {
  name                = "laws-avd_perfcounter_007"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  object_name         = "Memory"
  instance_name       = "*"
  counter_name        = "Pages/sec"
  interval_seconds    = 30
}
resource "azurerm_log_analytics_datasource_windows_performance_counter" "laws-avd_perfcounter_008" {
  name                = "laws-avd_perfcounter_008"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  object_name         = "Memory"
  instance_name       = "*"
  counter_name        = "% Committed Bytes In Use"
  interval_seconds    = 30
}
resource "azurerm_log_analytics_datasource_windows_performance_counter" "laws-avd_perfcounter_009" {
  name                = "laws-avd_perfcounter_009"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  object_name         = "PhysicalDisk"
  instance_name       = "*"
  counter_name        = "Avg. Disk Queue Length"
  interval_seconds    = 30
}
resource "azurerm_log_analytics_datasource_windows_performance_counter" "laws-avd_perfcounter_010" {
  name                = "laws-avd_perfcounter_010"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  object_name         = "PhysicalDisk"
  instance_name       = "*"
  counter_name        = "Avg. Disk sec/Read"
  interval_seconds    = 30
}
resource "azurerm_log_analytics_datasource_windows_performance_counter" "laws-avd_perfcounter_011" {
  name                = "laws-avd_perfcounter_011"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  object_name         = "PhysicalDisk"
  instance_name       = "*"
  counter_name        = "Avg. Disk sec/Transfer"
  interval_seconds    = 30
}
resource "azurerm_log_analytics_datasource_windows_performance_counter" "laws-avd_perfcounter_012" {
  name                = "laws-avd_perfcounter_012"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  object_name         = "PhysicalDisk"
  instance_name       = "*"
  counter_name        = "Avg. Disk sec/Write"
  interval_seconds    = 30
}
resource "azurerm_log_analytics_datasource_windows_performance_counter" "laws-avd_perfcounter_013" {
  name                = "laws-avd_perfcounter_013"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  object_name         = "Processor Information"
  instance_name       = "_Total"
  counter_name        = "% Processor Time"
  interval_seconds    = 30
}
resource "azurerm_log_analytics_datasource_windows_performance_counter" "laws-avd_perfcounter_014" {
  name                = "laws-avd_perfcounter_014"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  object_name         = "Terminal Services"
  instance_name       = "*"
  counter_name        = "Active Sessions"
  interval_seconds    = 60
}
resource "azurerm_log_analytics_datasource_windows_performance_counter" "laws-avd_perfcounter_015" {
  name                = "laws-avd_perfcounter_015"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  object_name         = "Terminal Services"
  instance_name       = "*"
  counter_name        = "Inactive Sessions"
  interval_seconds    = 60
}
resource "azurerm_log_analytics_datasource_windows_performance_counter" "laws-avd_perfcounter_016" {
  name                = "laws-avd_perfcounter_016"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  object_name         = "Terminal Services"
  instance_name       = "*"
  counter_name        = "Total Sessions"
  interval_seconds    = 60
}
resource "azurerm_log_analytics_datasource_windows_performance_counter" "laws-avd_perfcounter_017" {
  name                = "laws-avd_perfcounter_017"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  object_name         = "User Input Delay per Process"
  instance_name       = "*"
  counter_name        = "Max Input Delay"
  interval_seconds    = 30
}
resource "azurerm_log_analytics_datasource_windows_performance_counter" "laws-avd_perfcounter_018" {
  name                = "laws-avd_perfcounter_018"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  object_name         = "User Input Delay per Session"
  instance_name       = "*"
  counter_name        = "Max Input Delay"
  interval_seconds    = 30
}
resource "azurerm_log_analytics_datasource_windows_performance_counter" "laws-avd_perfcounter_019" {
  name                = "laws-avd_perfcounter_019"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  object_name         = "RemoteFX Network"
  instance_name       = "*"
  counter_name        = "Current TCP RTT"
  interval_seconds    = 30
}

resource "azurerm_log_analytics_datasource_windows_performance_counter" "laws-avd_perfcounter_020" {
  name                = "laws-avd_perfcounter_020"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  object_name         = "RemoteFX Network"
  instance_name       = "*"
  counter_name        = "Current UDP Bandwidth"
  interval_seconds    = 30
}

#########################
# Event Log Datasources #
#########################

resource "azurerm_log_analytics_datasource_windows_event" "laws-avd_eventlog_001" {
  name                = "laws-avd_eventlog_001"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  event_log_name      = "Microsoft-Windows-TerminalServices-RemoteConnectionManager/Admin"
  event_types         = ["Error","Warning","Information"]
}

resource "azurerm_log_analytics_datasource_windows_event" "laws-avd_eventlog_002" {
  name                = "laws-avd_eventlog_002"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  event_log_name      = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"
  event_types         = ["Error","Warning","Information"]
}

resource "azurerm_log_analytics_datasource_windows_event" "laws-avd_eventlog_003" {
  name                = "laws-avd_eventlog_003"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  event_log_name      = "System"
  event_types         = ["Error","Warning"]
}

resource "azurerm_log_analytics_datasource_windows_event" "laws-avd_eventlog_004" {
  name                = "laws-avd_eventlog_004"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  event_log_name      = "Microsoft-FSLogix-Apps/Admin"
  event_types         = ["Error","Warning","Information"]
}

resource "azurerm_log_analytics_datasource_windows_event" "laws-avd_eventlog_005" {
  name                = "laws-avd_eventlog_005"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  event_log_name      = "Microsoft-FSLogix-Apps/Operational"
  event_types         = ["Error","Warning","Information"]
}

resource "azurerm_log_analytics_datasource_windows_event" "laws-avd_eventlog_006" {
  name                = "laws-avd_eventlog_006"
  resource_group_name = azurerm_resource_group.rg.name
  workspace_name      = azurerm_log_analytics_workspace.laws-avd.name
  event_log_name      = "Application"
  event_types         = ["Error","Warning"]
}
