# RG
# Create a resource group for the Shared Resources
resource "azurerm_resource_group" "rg-spoke-visserskoning-shared" {
  #name     = "rg-spoke-${lower(var.deployment)}-shared-${var.environment}-${var.location_short}-${var.instance}"
  name     = local.shared_resource_group_name
  location = var.location
  tags     = merge(local.common_tags, {})
}