locals {
  common_tags = {
    "Deployment type" = "terraform"
    "Management type" = "terraform"
    "Environment"     = var.environment
    "Customer"        = var.nlcnumber
    #configuration        = var.configuration
    #"creation_timestamp" = timestamp()
  }

  network_resource_group_name = "rg-spoke-${lower(var.deployment)}-network-${var.environment}-${var.location_short}-${var.instance}"
  vnetname                    = "vnet-spoke-${lower(var.deployment)}-${var.environment}-${var.location_short}-${var.instance}"
  hub_gateway_ip              = "10.252.17.116"

  shared_resource_group_name   = "rg-spoke-${lower(var.deployment)}-shared-${var.environment}-${var.location_short}-${var.instance}"
}