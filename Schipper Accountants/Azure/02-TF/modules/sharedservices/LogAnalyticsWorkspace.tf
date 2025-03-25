# Create log analytics workspaces

### Creating monitoring workspace for generic monitoring ###
# Use of this should be controlled by Azure Policy
resource "azurerm_log_analytics_workspace" "log-shared" {
  name                = "${var.nlcnumber}-log-shared-weu-001"
  location            = azurerm_resource_group.rg-shared.location
  resource_group_name = azurerm_resource_group.rg-shared.name
  sku                 = "PerGB2018"
  tags = merge(var.common_tags,
    {
      Environment  = var.environment
      Customer     = var.nlcnumber
      Owner        = "Cloud"
    })
  }

### Creating monitoring workspace for 10x5 monitoring ###
# Use of this should be controlled by Azure Policy
resource "azurerm_log_analytics_workspace" "log-shared-002" {
  name                = "${var.nlcnumber}-log-shared-weu-002"
  location            = azurerm_resource_group.rg-shared.location
  resource_group_name = azurerm_resource_group.rg-shared.name
  sku                 = "PerGB2018"
  tags = merge(var.common_tags,
    {
      Environment  = var.environment
      Customer     = var.nlcnumber
      Owner        = "Cloud"
    })
  }

resource "azurerm_log_analytics_solution" "vminsights-002" {
  solution_name         = "VMInsights"
  location              = azurerm_resource_group.rg-shared.location
  resource_group_name   = azurerm_resource_group.rg-shared.name
  workspace_resource_id = azurerm_log_analytics_workspace.log-shared-002.id
  workspace_name        = azurerm_log_analytics_workspace.log-shared-002.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/VMInsights"
  }
  
  tags = merge(var.common_tags,
  {
    Environment  = var.environment
    Customer     = var.nlcnumber
    Owner        = "Cloud"
  })
}

### Creating monitoring workspace for 24x7 monitoring ###
# Use of this should be controlled by Azure Policy
resource "azurerm_log_analytics_workspace" "log-shared-003" {
  name                = "${var.nlcnumber}-log-shared-weu-003"
  location            = azurerm_resource_group.rg-shared.location
  resource_group_name = azurerm_resource_group.rg-shared.name
  sku                 = "PerGB2018"
  tags = merge(var.common_tags,
    {
      Environment  = var.environment
      Customer     = var.nlcnumber
      Owner        = "Cloud"
    })
  }

resource "azurerm_log_analytics_solution" "vminsights-003" {
  solution_name         = "VMInsights"
  location              = azurerm_resource_group.rg-shared.location
  resource_group_name   = azurerm_resource_group.rg-shared.name
  workspace_resource_id = azurerm_log_analytics_workspace.log-shared-003.id
  workspace_name        = azurerm_log_analytics_workspace.log-shared-003.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/VMInsights"
  }
  
  tags = merge(var.common_tags,
  {
    Environment  = var.environment
    Customer     = var.nlcnumber
    Owner        = "Cloud"
  })
}