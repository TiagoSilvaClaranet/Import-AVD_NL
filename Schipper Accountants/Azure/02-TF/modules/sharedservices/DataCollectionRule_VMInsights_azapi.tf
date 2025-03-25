# Create an Azure Monitoring Agent (AMA) Data Collection Rule to collect counters for VM Insights
# See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule
#
# If you also want to make use of the VM Insights MAP functions the Virtual Machines also needs to have the 'Dependancy Agent' installed
# Creates same DCR as DataCollectionRule_VMInsights.tf but uses AZAPI module. (Was needed before because azurerm module lacked some features)


resource "azapi_resource" "dcr-vminsights-azapi" {
  type      = "Microsoft.Insights/dataCollectionRules@2021-04-01"
  name      = "dcr-vminsights-azapi"
  parent_id = azurerm_resource_group.rg-shared.id
  location  = azurerm_resource_group.rg-shared.location

  body = jsonencode(
    {
      properties = {
        description  = "Data collection rule for VM Insights."

        dataFlows = [
          {
            destinations = ["VMInsightsPerf-Logs-Dest"]
            streams      = ["Microsoft-InsightsMetrics"]
          },
          {
            destinations = ["VMInsightsPerf-Logs-Dest"]
            streams      = ["Microsoft-ServiceMap"]
          }          
        ]

        dataSources = {
          extensions = [
            {
              extensionName = "DependencyAgent"
              name          = "DependencyAgentDataSource"
              streams       = ["Microsoft-ServiceMap"]
            }
          ]

          performanceCounters = [
            {
              counterSpecifiers          = ["\\VmInsights\\DetailedMetrics"]
              name                       = "VMInsightsPerfCounters"
              samplingFrequencyInSeconds = 60
              streams                    = ["Microsoft-InsightsMetrics"]
            }
          ]
        }

        destinations = {
          logAnalytics = [
            {
              name                = "VMInsightsPerf-Logs-Dest"
              workspaceResourceId = azurerm_log_analytics_workspace.log-shared.id
            }
          ]
        }
      }
    }
  )
}