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

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-dev" {
  application_group_id = module.avd-dev-dag.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}

#########################################################
# Desktop Application Groups - DEV - Applications
#########################################################
module "avd-dev-dag_notepad" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-dev.host_pool_id
  type           = "RemoteApp"
  name           = "vdag-notepad-dev-${var.location_short}-${var.instance}"
  friendly_name  = "Notepad (dev)"
  description    = "Notepad (dev)"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-dev]
}
module "avd-dev-dag_notepad_notepad" {
  source               = "./modules/tf-azurerm-avd-da"
  application_group_id = module.avd-dev-dag_notepad.dag_id
  name                 = "notepad"
  friendly_name        = "Notepad (dev)"
  description          = "Microsoft Notepad"
  path                 = "C:\\Windows\\Notepad.exe"
  icon_path            = "C:\\Windows\\Notepad.exe"
  icon_index           = 0
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-avd-dev-dag_notepad" {
  application_group_id = module.avd-dev-dag_notepad.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}


module "avd-dev-dag_word" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-dev.host_pool_id
  type           = "RemoteApp"
  name           = "vdag-word-dev-${var.location_short}-${var.instance}"
  friendly_name  = "Word (dev)"
  description    = "Word (dev)"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-dev]
}
module "avd-dev-dag_word_word" {
  source               = "./modules/tf-azurerm-avd-da"
  application_group_id = module.avd-dev-dag_word.dag_id
  name                 = "word"
  friendly_name        = "Word (dev)"
  description          = "Microsoft Word"
  path                 = "C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE" 
  icon_path            = "C:\\Program Files\\Microsoft Office\\Root\\VFS\\Windows\\Installer\\{90160000-000F-0000-1000-0000000FF1CE}\\wordicon.exe"
  icon_index           = 0
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-avd-dev-dag_word" {
  application_group_id = module.avd-dev-dag_word.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}

module "avd-dev-dag_caseware" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-dev.host_pool_id
  type           = "RemoteApp"
  name           = "vdag-caseware-dev-${var.location_short}-${var.instance}"
  friendly_name  = "Caseware (dev)"
  description    = "Caseware (dev)"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-dev]
}

module "avd-dev-dag_caseware_caseware" {
  source               = "./modules/tf-azurerm-avd-da"
  application_group_id = module.avd-dev-dag_caseware.dag_id
  name                 = "caseware"
  friendly_name        = "Caseware (dev)"
  description          = "Caseware"
  path                 = "C:\\Progs\\CaseWare\\Working Papers\\cwin64.exe" 
  icon_path            = "C:\\Progs\\CaseWare\\Working Papers\\cwin64.exe"
  icon_index           = 0
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-avd-dev-dag_caseware" {
  application_group_id = module.avd-dev-dag_caseware.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}
