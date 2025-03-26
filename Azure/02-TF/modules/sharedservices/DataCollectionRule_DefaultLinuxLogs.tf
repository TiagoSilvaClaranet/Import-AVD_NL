# Create Azure Monitoring Agent (AMA) Data Collection Rules
# See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule

# 10x5 Monitoring
resource "azurerm_monitor_data_collection_rule" "dcr-default-linuxlogs-monitoring-10x5" {
  name                = "dcr-default-linux-logs-monitoring-10x5"
  resource_group_name = azurerm_resource_group.rg-shared.name
  location            = var.location
  description         = "Default linux Logs Data Collection Rule 10x5."

  destinations {

    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.log-shared-002.id
      name                  = "shared-destination-log"
    }
  }

  data_flow {
      streams      = ["Microsoft-Syslog"]
      destinations = ["shared-destination-log"]
  }

  data_sources {

    syslog {
      streams        = ["Microsoft-Syslog"]
      facility_names = [
        "cron",
        "daemon",
        "kern",
        "syslog",
        "user"
        ]
      log_levels      = [
        "Info",
        "Notice",
        "Warning",
        "Error",
        "Critical",
        "Alert",
        "Emergency"
      ]
      name           = "default-linuxvm-logs"
    }
  }
 
  tags = merge(var.common_tags,
  {
    Environment  = var.environment
    Customer     = var.nlcnumber
    Owner        = "Cloud"
  })
}

# 24x7 Monitoring
resource "azurerm_monitor_data_collection_rule" "dcr-default-linuxlogs-monitoring-24x7" {
  name                = "dcr-default-linux-logs-monitoring-24x7"
  resource_group_name = azurerm_resource_group.rg-shared.name
  location            = var.location
  description         = "Default linux Logs Data Collection Rule 24x7."

  destinations {

    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.log-shared-003.id
      name                  = "shared-destination-log"
    }
  }

  data_flow {
      streams      = ["Microsoft-Syslog"]
      destinations = ["shared-destination-log"]
  }

  data_sources {

    syslog {
      streams        = ["Microsoft-Syslog"]
      facility_names = [
        "cron",
        "daemon",
        "kern",
        "syslog",
        "user"
        ]
      log_levels      = [
        "Info",
        "Notice",
        "Warning",
        "Error",
        "Critical",
        "Alert",
        "Emergency"
      ]
      name           = "default-linuxvm-logs"
    }
  }
 
  tags = merge(var.common_tags,
  {
    Environment  = var.environment
    Customer     = var.nlcnumber
    Owner        = "Cloud"
  })
}