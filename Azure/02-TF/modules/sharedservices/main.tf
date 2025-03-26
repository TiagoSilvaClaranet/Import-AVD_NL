# Get Azure Subscription details
data "azurerm_subscription" "current" {
}

# Create a resource group
resource "azurerm_resource_group" "rg-shared" {
  name     = "rg-shared-weu-${var.resourcesuffix}"
  location = var.location
  tags = merge(var.common_tags,
    {
      Environment = var.environment
      Customer    = var.nlcnumber
      Owner       = "Cloud"
  })
}

# Create Diagnostics Storage Account
resource "azurerm_storage_account" "stdiag" {
  name                     = "${lower(var.nlcnumber)}stdiagweu${lower(var.resourcesuffix)}"
  resource_group_name      = azurerm_resource_group.rg-shared.name
  location                 = azurerm_resource_group.rg-shared.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = merge(var.common_tags,
    {
      Environment = var.environment
      Customer    = var.nlcnumber
      Owner       = "Cloud"
  })
}

# Deploy alerting rules, action group and action rule
module "alerting" {
  count  = var.enable_alerting == true ? 1 : 0
  source = "./alerting"

  parentResourceId                    = azurerm_resource_group.rg-shared.id
  subscriptionId                      = data.azurerm_subscription.current.id
  logAnalyticsWorkspaceResourceId10x5  = azurerm_log_analytics_workspace.log-shared-002.id
  logAnalyticsWorkspaceResourceId24x7 = azurerm_log_analytics_workspace.log-shared-003.id
  nlcnumber                           = var.nlcnumber
  deploy_dev_action_rule              = var.deploy_dev_action_rule
}

# Associate Defender for Cloud to the shared LAW
resource "azurerm_security_center_workspace" "security-workspace" {
  scope        = "/subscriptions/${data.azurerm_subscription.current.subscription_id}"
  workspace_id = azurerm_log_analytics_workspace.log-shared.id

}

# Enable Defender for Cloud Security Posture management
# Assigns the 'Azure Security Benchmark' Azure Policy initiative to the subscription
resource "azurerm_subscription_policy_assignment" "asb_assignment" {
  name                 = "azuresecuritybenchmark"
  display_name         = "Azure Security Benchmark"
  policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8"
  subscription_id      = data.azurerm_subscription.current.id
}

resource "azurerm_automation_account" "aa-shared" {
  name                = "aa-shared-weu-${var.resourcesuffix}"
  location            = azurerm_resource_group.rg-shared.location
  resource_group_name = azurerm_resource_group.rg-shared.name

  sku_name = "Basic"

  tags = merge(var.common_tags,
    {
      Environment = var.environment
      Customer    = var.nlcnumber
      Owner       = "Cloud"
  })
}

# Link automation account to a Log Analytics Workspace.
# Only deployed if enable_update_management and/or enable_change_tracking are/is set to true
resource "azurerm_log_analytics_linked_service" "aa_linked_log_workspace" {
  count               = var.enable_update_management == true || var.enable_change_tracking == true ? 1 : 0
  resource_group_name = azurerm_resource_group.rg-shared.name
  workspace_id        = azurerm_log_analytics_workspace.log-shared.id
  read_access_id      = azurerm_automation_account.aa-shared.id
  #write_access_id     = azurerm_automation_account.aa-shared.id
}

# Enable Update Management solution
resource "azurerm_log_analytics_solution" "update_solution" {
  count = var.enable_update_management == true ? 1 : 0
  depends_on = [
    azurerm_log_analytics_linked_service.aa_linked_log_workspace
  ]
  solution_name         = "Updates"
  location              = azurerm_resource_group.rg-shared.location
  resource_group_name   = azurerm_resource_group.rg-shared.name
  workspace_resource_id = azurerm_log_analytics_workspace.log-shared.id
  workspace_name        = azurerm_log_analytics_workspace.log-shared.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Updates"
  }

  tags = merge(var.common_tags,
    {
      Environment = var.environment
      Customer    = var.nlcnumber
      Owner       = "Cloud"
  })
}

# Add Updates workspace solution to log analytics if enable_change_tracking is set to true.
# Adding this solution to the log analytics workspace, combined with above linked service resource enables Change Tracking and Inventory for the automation account.
resource "azurerm_log_analytics_solution" "change_tracking_solution" {
  count = var.enable_change_tracking == true ? 1 : 0
  depends_on = [
    azurerm_log_analytics_linked_service.aa_linked_log_workspace
  ]
  resource_group_name = azurerm_resource_group.rg-shared.name
  location            = azurerm_resource_group.rg-shared.location

  solution_name         = "ChangeTracking"
  workspace_resource_id = azurerm_log_analytics_workspace.log-shared.id
  workspace_name        = azurerm_log_analytics_workspace.log-shared.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ChangeTracking"
  }
}


/* Not yet implemented
# Send logs to Log Analytics
# Required for automation account with update management and/or change tracking enabled.
# Optional on automation accounts used of other purposes.
resource "azurerm_monitor_diagnostic_setting" "aa_diags_logs" {
  count                      = "${var.enable_logs_collection || var.enable_update_management || var.enable_change_tracking ? 1 : 0}"
  name                       = "LogsToLogAnalytics"
  target_resource_id         = "${azurerm_automation_account.aa.id}"
  log_analytics_workspace_id = "${var.log_analytics_workspace_id}"

  log {
    category = "JobLogs"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "JobStreams"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "DscNodeStatus"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled = false

    retention_policy {
      enabled = false
    }
  }
}


# Send metrics to Log Analytics
resource "azurerm_monitor_diagnostic_setting" "aa_diags_metrics" {
  count                      = "${var.enable_metrics_collection || var.enable_update_management || var.enable_change_tracking ? 1 : 0}"
  name                       = "MetricsToLogAnalytics"
  target_resource_id         = "${azurerm_automation_account.aa.id}"
  log_analytics_workspace_id = "${var.metrics_log_analytics_workspace_id}"

    log {
    category = "JobLogs"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "JobStreams"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "DscNodeStatus"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }
*/
