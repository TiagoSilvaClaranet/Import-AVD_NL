# RG
# Create a resource group for the Shared Resources
resource "azurerm_resource_group" "rg-spoke-schipper-shared" {
  #name     = "rg-spoke-${lower(var.deployment)}-shared-${var.environment}-${var.location_short}-${var.instance}"
  name     = local.shared_resource_group_name
  location = var.location
  tags     = merge(local.common_tags, {})
}

# Create a resource group for the Caseware Resources
resource "azurerm_resource_group" "rg-spoke-schipper-caseware" {
  name     = local.caseware_resource_group_name
  location = var.location
  tags     = merge(local.common_tags, {})
}

# Create a resource group for the SDU Resources
resource "azurerm_resource_group" "rg-spoke-schipper-sdu" {
  name     = local.sdu_resource_group_name
  location = var.location
  tags     = merge(local.common_tags, {})
}

# Create a resource group for the Rolls Resources
resource "azurerm_resource_group" "rg-spoke-schipper-rolls" {
  name     = local.rolls_resource_group_name
  location = var.location
  tags     = merge(local.common_tags, {})
}