############################################################
# Outputs General
############################################################

  data "azurerm_subscription" "current" {
  }

  output "current_subscription_display_name" {
    value = data.azurerm_subscription.current.display_name
  }

  output "current_subscription_subscription_id" {
    value = data.azurerm_subscription.current.subscription_id
  }

############################################################
# Outputs Module Network
# Included
# v1.0.0
############################################################

  output "hub_vnet_id" {
    value = module.network.hub_vnet_id
  }

  output "hub_vnet_name" {
    value = module.network.hub_vnet_name
  }

  output "hub_vnet_resource_group_name" {
    value = module.network.hub_vnet_resource_group_name
  }

############################################################
# Outputs Module Management Services
# Worksmart365-Azure-Hub-Modules-Management
# v1.0.0
############################################################

  output "mt01-password" {
    value     = module.mgmt.mt01-localpassword
    sensitive = true 
  }

############################################################
# Outputs Module Identity
# tf-azure-adds
# v1.0.0
############################################################

  # Output Identity Module outputs when module is enabled
  output "dc01-password" {
    value     = var.deploy_identity == true ? module.identity[0].dc01-password : "" 
    sensitive = true 
  }

  output "dc02-password" {
    value     = var.deploy_identity == true ? module.identity[0].dc02-password : "" 
    sensitive = true 
  }

  output "safemode-admin-password" {
    value = var.deploy_identity == true ? module.identity[0].safemode-admin-password : "" 
    sensitive = true 
  }

############################################################
# Outputs Module Shared Fileserver
# included
# v1.0.0
############################################################

  output "sharedfileserver-password" {
    value     = var.deploy_sharedfileserver == true ? module.sharedfileserver[0].sharedfileserver-local-password : ""
    sensitive = true
  }

############################################################
# Outputs Module Fortigate
# tf-azure-fortigate
# v1.0.4
############################################################

  output "fgt01_password" {
    value = var.deploy_fortigate == true ? module.fortigate[0].fgt01_password : ""
    sensitive = true
  }



