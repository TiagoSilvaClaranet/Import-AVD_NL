# Create Azure Monitoring Agent (AMA) Data Collection Rule for AVD Session Hosts
# See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule

resource "azurerm_monitor_data_collection_rule" "dcr-avd-sessionhost-monitoring" {
  name                = "dcr-avd-sessionhost-monitoring"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  description         = "AVD Session Host Data Collection Rule."

  destinations {
    azure_monitor_metrics {
      name = "avd-destination-metrics"
    }

    # log_analytics {
    #   workspace_resource_id = azurerm_log_analytics_workspace.laws-avd.id
    #   name                  = "avd-destination-log"
    # }
  }

  data_flow {
      streams      = ["Microsoft-InsightsMetrics"]
      destinations = ["avd-destination-metrics"]
  }

  # data_flow {
  #     streams      = ["Microsoft-Event"]
  #     destinations = ["avd-destination-log"]
  # }

  data_sources {
      performance_counter {
      streams                       = ["Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 10
      counter_specifiers            = ["\\Processor Information(_Total)\\% Processor Time",
                                        "\\Processor Information(_Total)\\% Privileged Time",
                                        "\\Processor Information(_Total)\\% User Time",
                                        "\\Processor Information(_Total)\\Processor Frequency",
                                        "\\System\\Processes",
                                        "\\Process(_Total)\\Thread Count",
                                        "\\Process(_Total)\\Handle Count",
                                        "\\System\\System Up Time",
                                        "\\System\\Context Switches/sec",
                                        "\\System\\Processor Queue Length",
                                        "\\Memory\\% Committed Bytes In Use",
                                        "\\Memory\\Available Bytes",
                                        "\\Memory\\Committed Bytes",
                                        "\\Memory\\Cache Bytes",
                                        "\\Memory\\Pool Paged Bytes",
                                        "\\Memory\\Pool Nonpaged Bytes",
                                        "\\Memory\\Pages/sec",
                                        "\\Memory\\Page Faults/sec",
                                        "\\Process(_Total)\\Working Set",
                                        "\\Process(_Total)\\Working Set - Private",
                                        "\\LogicalDisk(_Total)\\% Disk Time",
                                        "\\LogicalDisk(_Total)\\% Disk Read Time",
                                        "\\LogicalDisk(_Total)\\% Disk Write Time",
                                        "\\LogicalDisk(_Total)\\% Idle Time",
                                        "\\LogicalDisk(_Total)\\Disk Bytes/sec",
                                        "\\LogicalDisk(_Total)\\Disk Read Bytes/sec",
                                        "\\LogicalDisk(_Total)\\Disk Write Bytes/sec",
                                        "\\LogicalDisk(_Total)\\Disk Transfers/sec",
                                        "\\LogicalDisk(_Total)\\Disk Reads/sec",
                                        "\\LogicalDisk(_Total)\\Disk Writes/sec",
                                        "\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer",
                                        "\\LogicalDisk(_Total)\\Avg. Disk sec/Read",
                                        "\\LogicalDisk(_Total)\\Avg. Disk sec/Write",
                                        "\\LogicalDisk(_Total)\\Avg. Disk Queue Length",
                                        "\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length",
                                        "\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length",
                                        "\\LogicalDisk(_Total)\\% Free Space",
                                        "\\LogicalDisk(_Total)\\Free Megabytes",
                                        "\\Network Interface(*)\\Bytes Total/sec",
                                        "\\Network Interface(*)\\Bytes Sent/sec",
                                        "\\Network Interface(*)\\Bytes Received/sec",
                                        "\\Network Interface(*)\\Packets/sec",
                                        "\\Network Interface(*)\\Packets Sent/sec",
                                        "\\Network Interface(*)\\Packets Received/sec",
                                        "\\Network Interface(*)\\Packets Outbound Errors",
                                        "\\Network Interface(*)\\Packets Received Errors",
                                        "\\LogicalDisk(*)\\% Free Space",
                                    ]
      name                          = "default-avd-perfcounters"
      #name                          = "perfCounterDataSource10"
    }

    # windows_event_log {
    #   streams        = ["Microsoft-Event"]
    #   x_path_queries = [
    #                     "Application!*[System[(Level=1 or Level=2 or Level=3 or Level=4)]]",
    #                     "System!*[System[(Level=1 or Level=2 or Level=3 or Level=4)]]"
    #                    ]
    #   #name           = "eventLogsDataSource"
    #   name           = "default-windowsvm-logs"
    # }


  }
 
  tags = merge(var.common_tags,
  {
    Environment  = var.environment
    Customer     = var.nlcnumber
    Owner        = "Cloud"
  })

  
}