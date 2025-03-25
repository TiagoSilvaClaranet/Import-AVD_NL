#########################################################
# Host Pools
#########################################################

module "avd-hostpool-uat" {
  source         = "./modules/tf-azurerm-avd-hostpool"
  name           = "vdpool-${lower(var.hostpool_name)}-uat-${var.location_short}-${var.instance}"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  friendly_name  = "AVD Generic Acceptatie Host Pool"
  nlcnumber      = local.nlcnumber
  hostpool_name_short = var.hostpool_name_short
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
}

#########################################################
# Desktop
#########################################################

module "avd-uat-dag" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-uat.host_pool_id
  type           = "Desktop"
  default_desktop_display_name = "Desktop (uat)"
  name           = "vdag-desktop-uat-${var.location_short}-${var.instance}"
  friendly_name  = "Desktop Application Group (uat)"
  description    = "Desktop Application Group (uat)"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-uat]
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-uat" {
  application_group_id = module.avd-uat-dag.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}


#########################################################
# Office 365 - Word
#########################################################

module "avd-uat-dag_word" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-uat.host_pool_id
  type           = "RemoteApp"
  name           = "vdag-word-uat-${var.location_short}-${var.instance}"
  friendly_name  = "Word (uat)"
  description    = "Word (uat)"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-uat]
}
module "avd-uat-dag_word_word" {
  source               = "./modules/tf-azurerm-avd-da"
  application_group_id = module.avd-uat-dag_word.dag_id
  name                 = "word"
  friendly_name        = "Word (uat)"
  description          = "Microsoft Word"
  path                 = "C:\\Program Files (x86)\\Microsoft Office\\root\\Office16\\WINWORD.EXE" 
  icon_path            = "C:\\Program Files (x86)\\Microsoft Office\\root\\Office16\\WINWORD.EXE"
  icon_index           = 0
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-avd-uat-dag_word" {
  application_group_id = module.avd-uat-dag_word.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}


#########################################################
# CaseWare
#########################################################

module "avd-uat-dag_caseware" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-uat.host_pool_id
  type           = "RemoteApp"
  name           = "vdag-caseware-uat-${var.location_short}-${var.instance}"
  friendly_name  = "Caseware (uat)"
  description    = "Caseware (uat)"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-uat]
}

module "avd-uat-dag_caseware_caseware" {
  source               = "./modules/tf-azurerm-avd-da"
  application_group_id = module.avd-uat-dag_caseware.dag_id
  name                 = "caseware"
  friendly_name        = "Caseware (uat)"
  description          = "Caseware"
  path                 = "C:\\Progs\\CaseWare\\Working Papers\\cwin64.exe" 
  icon_path            = "C:\\Progs\\CaseWare\\Working Papers\\cwin64.exe"
  icon_index           = 0
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-avd-uat-dag_caseware" {
  application_group_id = module.avd-uat-dag_caseware.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}

#########################################################
# CaseWare Toolbox
#########################################################

module "avd-uat-dag_toolbox" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-uat.host_pool_id
  type           = "RemoteApp"
  name           = "vdag-toolbox-uat-${var.location_short}-${var.instance}"
  friendly_name  = "Caseware Toolbox (uat)"
  description    = "Caseware Toolbox (uat)"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-uat]
}

module "avd-uat-dag_toolbox_toolbox" {
  source               = "./modules/tf-azurerm-avd-da"
  application_group_id = module.avd-uat-dag_toolbox.dag_id
  name                 = "toolbox"
  friendly_name        = "Caseware Toolbox (uat)"
  description          = "Caseware Toolbox"
  path                 = "C:\\Progs\\CaseWare Toolbox\\Toolbox.exe.lnk" 
  icon_path            = "C:\\Progs\\CaseWare\\Working Papers\\cwin64.exe"
  icon_index           = 0
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-avd-uat-dag_toolbox" {
  application_group_id = module.avd-uat-dag_toolbox.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}

#########################################################
# ActivMan
#########################################################

module "avd-uat-dag_activman" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-uat.host_pool_id
  type           = "RemoteApp"
  name           = "vdag-activman-uat-${var.location_short}-${var.instance}"
  friendly_name  = "Activman (uat)"
  description    = "Activman (uat)"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-uat]
}

module "avd-uat-dag_activman_activman" {
  source               = "./modules/tf-azurerm-avd-da"
  application_group_id = module.avd-uat-dag_activman.dag_id
  name                 = "activman"
  friendly_name        = "Activman (uat)"
  description          = "Activman"
  path                 = "C:\\Progs\\ActivMan\\ActiveMan.exe.lnk" 
  icon_path            = "C:\\Progs\\ActivMan\\am.exe"
  icon_index           = 0
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-avd-uat-dag_activman" {
  application_group_id = module.avd-uat-dag_activman.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}

#########################################################
# ActivMan Nieuwe Administratie
#########################################################

module "avd-uat-dag_activman_nieuweadministratie" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-uat.host_pool_id
  type           = "RemoteApp"
  name           = "vdag-activman-nieuweadministratie-uat-${var.location_short}-${var.instance}"
  friendly_name  = "Activman - Nieuwe Administratie (uat)"
  description    = "Activman - Nieuwe Administratie (uat)"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-uat]
}

module "avd-uat-dag_activman_nieuweadministratie_activman_nieuweadministratie" {
  source               = "./modules/tf-azurerm-avd-da"
  application_group_id = module.avd-uat-dag_activman_nieuweadministratie.dag_id
  name                 = "activman"
  friendly_name        = "Activman - Nieuwe Administratie (uat)"
  description          = "Activman - Nieuwe Administratie"
  path                 = "C:\\Progs\\ActivMan\\ActiveMan Nieuwe Administratie.lnk" 
  icon_path            = "C:\\Progs\\ActivMan\\am.exe"
  icon_index           = 0
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-avd-uat-dag_activman_nieuweadministratie" {
  application_group_id = module.avd-uat-dag_activman_nieuweadministratie.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}

#########################################################
# SDU Belasting Office
#########################################################

module "avd-uat-dag_sdu" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-uat.host_pool_id
  type           = "RemoteApp"
  name           = "vdag-sdu-uat-${var.location_short}-${var.instance}"
  friendly_name  = "SDU (uat)"
  description    = "SDU (uat)"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-uat]
}
module "avd-uat-dag_sdu_sdu" {
  source               = "./modules/tf-azurerm-avd-da"
  application_group_id = module.avd-uat-dag_sdu.dag_id
  name                 = "SDU"
  friendly_name        = "SDU (uat)"
  description          = "SDU Belasting Office"
  path                 = "C:\\Program Files (x86)\\Sdu\\Belasting Office\\Bin\\sbo.exe"
  icon_path            = "C:\\Program Files (x86)\\Sdu\\Belasting Office\\Bin\\sbo.exe"
  icon_index           = 0
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-avd-uat-dag_sdu" {
  application_group_id = module.avd-uat-dag_sdu.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}
