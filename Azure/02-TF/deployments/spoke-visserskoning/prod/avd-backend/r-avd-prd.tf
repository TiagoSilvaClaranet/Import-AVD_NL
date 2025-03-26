#########################################################
# Host Pools
#########################################################

module "avd-hostpool-prd" {
  source         = "./modules/tf-azurerm-avd-hostpool"
  name           = "vdpool-${lower(var.hostpool_name)}-prd-${var.location_short}-${var.instance}"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  friendly_name  = "AVD Generic Productie Host Pool"
  nlcnumber      = local.nlcnumber
  hostpool_name_short = var.hostpool_name_short
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
}

#########################################################
# Desktop
#########################################################

module "avd-prd-dag" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-prd.host_pool_id
  type           = "Desktop"
  default_desktop_display_name = "Desktop"
  name           = "vdag-desktop-prd-${var.location_short}-${var.instance}"
  friendly_name  = "Desktop Application Group"
  description    = "Desktop Application Group"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-prd]
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-prd" {
  application_group_id = module.avd-prd-dag.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}


