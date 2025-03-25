# Prerequisites
# ADDS domain present and reachable
# DNS servers of vnet pointing to the Domain Controllers

# Resource group name is output when execution plan is applied.
resource "azurerm_resource_group" "rg" {
  name     = "rg-spoke-${var.spokename}-avd-prod-${var.location_short}-${var.instance}"
  location = var.location
}
#########################################################
# Host Pools
#########################################################
module "avd-hostpool-dev" {
  source         = "./modules/tf-azurerm-avd-hostpool"
  name           = "vdpool-${lower(var.hostpool_name)}-dev-${var.location_short}-${var.instance}"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  friendly_name  = "AVD Generic Development Host Pool"
  nlcnumber      = local.nlcnumber
  hostpool_name_short = var.hostpool_name_short
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
}

module "avd-hostpool-tst" {
  source         = "./modules/tf-azurerm-avd-hostpool"
  name           = "vdpool-${lower(var.hostpool_name)}-tst-${var.location_short}-${var.instance}"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  friendly_name  = "AVD Generic Test Host Pool"
  nlcnumber      = local.nlcnumber
  hostpool_name_short = var.hostpool_name_short
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
}




#########################################################
# Desktop Application Groups - Desktops
#########################################################
module "avd-dev-dag" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-dev.host_pool_id
  type           = "Desktop"
  default_desktop_display_name = "Desktop (dev)"
  name           = "vdag-desktop-dev-${var.location_short}-${var.instance}"
  friendly_name  = "Desktop Application Group (dev)"
  description    = "Desktop Application Group (dev)"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-dev]
}

module "avd-tst-dag" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-tst.host_pool_id
  type           = "Desktop"
  default_desktop_display_name = "Desktop (test)"
  name           = "vdag-desktop-tst-${var.location_short}-${var.instance}"
  friendly_name  = "Desktop Application Group (tst)"
  description    = "Desktop Application Group (tst)"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-tst]
}









#########################################################
# Workspaces
#########################################################
# module "avd-workspace" {
#   source         = "./modules/tf-azurerm-avd-workspace"
#   name           = "vdws-workspace-dev-${var.location_short}-${var.instance}"
#   resource_group = azurerm_resource_group.rg.name
#   location       = azurerm_resource_group.rg.location
#   friendly_name  = "Worksmart365 Workspace"
#   description    = "Worksmart365 Workspace"
#   nlcnumber      = local.nlcnumber
# }

module "avd-workspace" {
  source         = "./modules/tf-azurerm-avd-workspace"
  name           = "vdws-workspace-dev-${var.location_short}-${var.instance}"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  friendly_name  = "Schipper Accountants"
  description    = "Schipper Accountants"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
}

module "avd-workspace-prd" {
  source         = "./modules/tf-azurerm-avd-workspace"
  name           = "vdws-workspace-prd-${var.location_short}-${var.instance}"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  friendly_name  = "Schipper Accountants"
  description    = "Schipper Accountants"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
}

#########################################################
# Associate DAG(s) to Workspace(s)
#########################################################
resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-dev" {
  application_group_id = module.avd-dev-dag.dag_id
  workspace_id         = module.avd-workspace-prd.workspace_id
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-test" {
  application_group_id = module.avd-tst-dag.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}






#########################################################
# Add a resource group for future session hosts
#########################################################
resource "azurerm_resource_group" "rg-sessionhosts-dev" {
  name     = "rg-spoke-${var.spokename}-avd-sessionhosts-dev-${var.location_short}-${var.instance}"
  location = var.location
}

resource "azurerm_resource_group" "rg-sessionhosts-test" {
  name     = "rg-spoke-${var.spokename}-avd-sessionhosts-test-${var.location_short}-${var.instance}"
  location = var.location
}

resource "azurerm_resource_group" "rg-sessionhosts-uat" {
  name     = "rg-spoke-${var.spokename}-avd-sessionhosts-uat-${var.location_short}-${var.instance}"
  location = var.location
}

resource "azurerm_resource_group" "rg-sessionhosts-prd" {
  name     = "rg-spoke-${var.spokename}-avd-sessionhosts-prd-${var.location_short}-${var.instance}"
  location = var.location
}

