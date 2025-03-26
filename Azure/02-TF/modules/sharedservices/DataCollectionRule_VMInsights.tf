# Create an Azure Monitoring Agent (AMA) Data Collection Rule to collect counters for VM Insights
# See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule
#
# If you also want to make use of the VM Insights MAP functions the Virtual Machines also needs to have the 'Dependancy Agent' installed
# azurerm >= v3.29.0  is needed for support if Microsoft-ServiceMap support


resource "azurerm_monitor_data_collection_rule" "dcr-vminsights" {
  name                = "dcr-vminsights"
  resource_group_name = azurerm_resource_group.rg-shared.name
  location            = var.location
  description         = "VM Data Collection Rule for VM Insights."

  destinations {
    azure_monitor_metrics {
      name = "azureMonitorMetrics-default"
    }
  
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.log-shared.id
      name                  = "shared-destination-log"
    }
  }

  data_flow {
      streams      = ["Microsoft-InsightsMetrics"]
      #destinations = ["azureMonitorMetrics-default"]  #  Commented out. Still need to log to LAW. Sending to metrics directly does not yet work
      destinations = ["shared-destination-log"]
  }

  data_flow {
      streams      = ["Microsoft-ServiceMap"]
      destinations = ["shared-destination-log"]
  }

  data_sources {
    performance_counter {
      streams                       = ["Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 60
      counter_specifiers            = ["\\VmInsights\\DetailedMetrics"]
      name                          = "VMInsightsPerfCounters"
    }
    
    extension {
      streams                       = ["Microsoft-ServiceMap"]  # Not yet supported by azurerm module v3.15.0 (Fixed in v3.29.0?)
      extension_name                = "DependencyAgent"
      #extension_json                = jsonencode({})
      name                          = "DependencyAgentDataSource"
    }
  }
  
 
  tags = merge(var.common_tags,
  {
    Environment  = var.environment
    Customer     = var.nlcnumber
    Owner        = "Cloud"
  })
  
}