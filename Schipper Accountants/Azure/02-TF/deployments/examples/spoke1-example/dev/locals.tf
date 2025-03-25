locals {
  common_tags = {
    "Deployment type"     = "terraform"
    "Management type"     = "terraform"
    "Environment"         = var.environment
    #configuration       = var.configuration
    "creation_timestamp"  = timestamp()
  }

  network_resource_group_name = "rg-${lower(var.deployment)}-network-${var.environment}-${var.location_short}-002"
  vnetname                    = "vnet-spoke1-${var.environment}-${var.location_short}-001"
}