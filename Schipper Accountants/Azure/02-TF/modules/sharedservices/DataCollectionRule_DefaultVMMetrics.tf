# Create Azure Monitoring Agent (AMA) Data Collection Rules
# See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule

resource "azurerm_monitor_data_collection_rule" "dcr-default-vmmetrics-monitoring" {
  name                = "dcr-default-vm-metrics-monitoring"
  resource_group_name = azurerm_resource_group.rg-shared.name
  location            = var.location
  description         = "Default VM Metrics Data Collection Rule."

  destinations {

    azure_monitor_metrics {
      name = "shared-destination-metrics"
    }
  }

  data_flow {
      streams      = ["Microsoft-InsightsMetrics"]
      destinations = ["shared-destination-metrics"]
  }


  data_sources {
      performance_counter {
      streams                       = ["Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 60
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
      name                          = "default-vm-perfcounters"
    }
  }
 
  tags = merge(var.common_tags,
  {
    Environment  = var.environment
    Customer     = var.nlcnumber
    Owner        = "Cloud"
  })

  
}