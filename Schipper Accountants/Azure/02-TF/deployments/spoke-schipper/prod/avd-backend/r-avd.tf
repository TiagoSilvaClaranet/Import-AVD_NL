# Prerequisites
# ADDS domain present and reachable
# DNS servers of vnet pointing to the Domain Controllers

# Resource group name is output when execution plan is applied.
resource "azurerm_resource_group" "rg" {
  name     = "rg-spoke-${var.spokename}-avd-prod-${var.location_short}-${var.instance}"
  location = var.location
}
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
# Add a resource group for future session hosts
#########################################################
resource "azurerm_resource_group" "rg-sessionhosts-dev" {
  name     = "rg-spoke-${var.spokename}-avd-sessionhosts-dev-${var.location_short}-${var.instance}"
  location = var.location
}

resource "azurerm_resource_group" "rg-sessionhosts-tst" {
  name     = "rg-spoke-${var.spokename}-avd-sessionhosts-tst-${var.location_short}-${var.instance}"
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

