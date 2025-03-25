#########################################################
# Host Pools
#########################################################

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

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-test" {
  application_group_id = module.avd-tst-dag.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}


#########################################################
# Desktop Application Groups - TEST - Applications
#########################################################

module "avd-tst-dag_word" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-tst.host_pool_id
  type           = "RemoteApp"
  name           = "vdag-word-tst-${var.location_short}-${var.instance}"
  friendly_name  = "Word (tst)"
  description    = "Word (tst)"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-dev]
}
module "avd-tst-dag_word_word" {
  source               = "./modules/tf-azurerm-avd-da"
  application_group_id = module.avd-tst-dag_word.dag_id
  name                 = "word"
  friendly_name        = "Word (tst)"
  description          = "Microsoft Word"
  path                 = "C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE" 
  icon_path            = "C:\\Program Files\\Microsoft Office\\Root\\VFS\\Windows\\Installer\\{90160000-000F-0000-1000-0000000FF1CE}\\wordicon.exe"
  icon_index           = 0
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-avd-tst-dag_word" {
  application_group_id = module.avd-tst-dag_word.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}