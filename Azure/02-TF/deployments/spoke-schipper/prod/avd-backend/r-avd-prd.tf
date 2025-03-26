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


#########################################################
# CaseWare
#########################################################

module "avd-prd-dag_caseware" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-prd.host_pool_id
  type           = "RemoteApp"
  name           = "vdag-caseware-prd-${var.location_short}-${var.instance}"
  friendly_name  = "Caseware"
  description    = "Caseware"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-prd]
}

module "avd-prd-dag_caseware_caseware" {
  source               = "./modules/tf-azurerm-avd-da"
  application_group_id = module.avd-prd-dag_caseware.dag_id
  name                 = "caseware"
  friendly_name        = "Caseware"
  description          = "Caseware"
  path                 = "C:\\Progs\\CaseWare\\Working Papers\\cwin64.exe" 
  icon_path            = "C:\\Progs\\CaseWare\\Working Papers\\cwin64.exe"
  icon_index           = 0
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-avd-prd-dag_caseware" {
  application_group_id = module.avd-prd-dag_caseware.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}

#########################################################
# Office 365 - Word
#########################################################

module "avd-prd-dag_word" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-prd.host_pool_id
  type           = "RemoteApp"
  name           = "vdag-word-prd-${var.location_short}-${var.instance}"
  friendly_name  = "Word"
  description    = "Word"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-prd]
}
module "avd-prd-dag_word_word" {
  source               = "./modules/tf-azurerm-avd-da"
  application_group_id = module.avd-prd-dag_word.dag_id
  name                 = "word"
  friendly_name        = "Word"
  description          = "Microsoft Word"
  path                 = "C:\\Program Files (x86)\\Microsoft Office\\root\\Office16\\WINWORD.EXE" 
  icon_path            = "C:\\Program Files (x86)\\Microsoft Office\\root\\Office16\\WINWORD.EXE"
  icon_index           = 0
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-avd-prd-dag_word" {
  application_group_id = module.avd-prd-dag_word.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}

#########################################################
# CaseWare Toolbox
#########################################################

module "avd-prd-dag_toolbox" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-prd.host_pool_id
  type           = "RemoteApp"
  name           = "vdag-toolbox-prd-${var.location_short}-${var.instance}"
  friendly_name  = "Caseware Toolbox"
  description    = "Caseware Toolbox"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-prd]
}

module "avd-prd-dag_toolbox_toolbox" {
  source               = "./modules/tf-azurerm-avd-da"
  application_group_id = module.avd-prd-dag_toolbox.dag_id
  name                 = "toolbox"
  friendly_name        = "Caseware Toolbox"
  description          = "Caseware Toolbox"
  path                 = "C:\\Progs\\CaseWare Toolbox\\Toolbox.exe.lnk" 
  icon_path            = "C:\\Progs\\CaseWare\\Working Papers\\cwin64.exe"
  icon_index           = 0
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-avd-prd-dag_toolbox" {
  application_group_id = module.avd-prd-dag_toolbox.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}

#########################################################
# ActivMan
#########################################################

module "avd-prd-dag_activman" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-prd.host_pool_id
  type           = "RemoteApp"
  name           = "vdag-activman-prd-${var.location_short}-${var.instance}"
  friendly_name  = "Activman"
  description    = "Activman"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-prd]
}

module "avd-prd-dag_activman_activman" {
  source               = "./modules/tf-azurerm-avd-da"
  application_group_id = module.avd-prd-dag_activman.dag_id
  name                 = "activman"
  friendly_name        = "Activman"
  description          = "Activman"
  path                 = "C:\\Progs\\ActivMan\\ActiveMan.exe.lnk" 
  icon_path            = "C:\\Progs\\ActivMan\\am.exe"
  icon_index           = 0
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-avd-prd-dag_activman" {
  application_group_id = module.avd-prd-dag_activman.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}

#########################################################
# ActivMan Nieuwe Administratie
#########################################################

module "avd-prd-dag_activman_nieuweadministratie" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-prd.host_pool_id
  type           = "RemoteApp"
  name           = "vdag-activman-nieuweadministratie-prd-${var.location_short}-${var.instance}"
  friendly_name  = "Activman - Nieuwe Administratie"
  description    = "Activman - Nieuwe Administratie"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-prd]
}

module "avd-prd-dag_activman_nieuweadministratie_activman_nieuweadministratie" {
  source               = "./modules/tf-azurerm-avd-da"
  application_group_id = module.avd-prd-dag_activman_nieuweadministratie.dag_id
  name                 = "activman"
  friendly_name        = "Activman - Nieuwe Administratie"
  description          = "Activman - Nieuwe Administratie"
  path                 = "C:\\Progs\\ActivMan\\ActiveMan Nieuwe Administratie.lnk" 
  icon_path            = "C:\\Progs\\ActivMan\\am.exe"
  icon_index           = 0
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-avd-prd-dag_activman_nieuweadministratie" {
  application_group_id = module.avd-prd-dag_activman_nieuweadministratie.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}

#########################################################
# Elsevier
#########################################################

module "avd-prd-dag_elsevier" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-prd.host_pool_id
  type           = "RemoteApp"
  name           = "vdag-elsevier-prd-${var.location_short}-${var.instance}"
  friendly_name  = "Elsevier"
  description    = "Elsevier"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-prd]
}

module "avd-prd-dag_elsevier_erfwin2022" {
    source               = "./modules/tf-azurerm-avd-da"
    application_group_id = module.avd-prd-dag_elsevier.dag_id
    name                 = "elsevier-erfwin2022"
    friendly_name        = "Elsevier - ErfWin2022"
    description          = "Elsevier - ErfWin2022"
    path                 = "C:\\Progs\\Elsevier\\2022\\ErfWin2022.lnk" 
    icon_path            = "c:\\Progs\\Elsevier\\IconFiles\\ErfWin.exe"
    icon_index           = 0
  }

module "avd-prd-dag_elsevier_erfwin2021" {
    source               = "./modules/tf-azurerm-avd-da"
    application_group_id = module.avd-prd-dag_elsevier.dag_id
    name                 = "elsevier-erfwin2021"
    friendly_name        = "Elsevier - ErfWin2021"
    description          = "Elsevier - ErfWin2021"
    path                 = "C:\\Progs\\Elsevier\\2021\\ErfWin2021.lnk" 
    icon_path            = "c:\\Progs\\Elsevier\\IconFiles\\ErfWin.exe"
    icon_index           = 0
  }
  
  module "avd-prd-dag_elsevier_erfwin2020" {
    source               = "./modules/tf-azurerm-avd-da"
    application_group_id = module.avd-prd-dag_elsevier.dag_id
    name                 = "elsevier-erfwin2020"
    friendly_name        = "Elsevier - ErfWin2020"
    description          = "Elsevier - ErfWin2020"
    path                 = "C:\\Progs\\Elsevier\\2020\\ErfWin2020.lnk" 
    icon_path            = "c:\\Progs\\Elsevier\\IconFiles\\ErfWin.exe"
    icon_index           = 0
  }
  
  module "avd-prd-dag_elsevier_erfwin2019" {
    source               = "./modules/tf-azurerm-avd-da"
    application_group_id = module.avd-prd-dag_elsevier.dag_id
    name                 = "elsevier-erfwin2019"
    friendly_name        = "Elsevier - ErfWin2019"
    description          = "Elsevier - ErfWin2019"
    path                 = "C:\\Progs\\Elsevier\\2019\\ErfWin2019.lnk" 
    icon_path            = "c:\\Progs\\Elsevier\\IconFiles\\ErfWin.exe"
    icon_index           = 0
  }
  
  module "avd-prd-dag_elsevier_erfwin2018" {
    source               = "./modules/tf-azurerm-avd-da"
    application_group_id = module.avd-prd-dag_elsevier.dag_id
    name                 = "elsevier-erfwin2018"
    friendly_name        = "Elsevier - ErfWin2018"
    description          = "Elsevier - ErfWin2018"
    path                 = "C:\\Progs\\Elsevier\\2018\\ErfWin2018.lnk" 
    icon_path            = "c:\\Progs\\Elsevier\\IconFiles\\ErfWin.exe"
    icon_index           = 0
  }
  
  module "avd-prd-dag_elsevier_erfwin2017" {
    source               = "./modules/tf-azurerm-avd-da"
    application_group_id = module.avd-prd-dag_elsevier.dag_id
    name                 = "elsevier-erfwin2017"
    friendly_name        = "Elsevier - ErfWin2017"
    description          = "Elsevier - ErfWin2017"
    path                 = "C:\\Progs\\Elsevier\\2017\\ErfWin2017.lnk" 
    icon_path            = "c:\\Progs\\Elsevier\\IconFiles\\ErfWin.exe"
    icon_index           = 0
  }
  
  module "avd-prd-dag_elsevier_erfwin2016" {
    source               = "./modules/tf-azurerm-avd-da"
    application_group_id = module.avd-prd-dag_elsevier.dag_id
    name                 = "elsevier-erfwin2016"
    friendly_name        = "Elsevier - ErfWin2016"
    description          = "Elsevier - ErfWin2016"
    path                 = "C:\\Progs\\Elsevier\\2016\\ErfWin2016.lnk" 
    icon_path            = "c:\\Progs\\Elsevier\\IconFiles\\ErfWin.exe"
    icon_index           = 0
  }

  module "avd-prd-dag_elsevier_schwin2022" {
    source               = "./modules/tf-azurerm-avd-da"
    application_group_id = module.avd-prd-dag_elsevier.dag_id
    name                 = "elsevier-schwin2022"
    friendly_name        = "Elsevier - SchWin2022"
    description          = "Elsevier - SchWin2022"
    path                 = "C:\\Progs\\Elsevier\\2022\\SchWin2022.lnk" 
    icon_path            = "c:\\Progs\\Elsevier\\IconFiles\\SchWin.exe"
    icon_index           = 0
  }

  module "avd-prd-dag_elsevier_schwin2021" {
    source               = "./modules/tf-azurerm-avd-da"
    application_group_id = module.avd-prd-dag_elsevier.dag_id
    name                 = "elsevier-schwin2021"
    friendly_name        = "Elsevier - SchWin2021"
    description          = "Elsevier - SchWin2021"
    path                 = "C:\\Progs\\Elsevier\\2021\\SchWin2021.lnk" 
    icon_path            = "c:\\Progs\\Elsevier\\IconFiles\\SchWin.exe"
    icon_index           = 0
  }
  
  module "avd-prd-dag_elsevier_schwin2020" {
    source               = "./modules/tf-azurerm-avd-da"
    application_group_id = module.avd-prd-dag_elsevier.dag_id
    name                 = "elsevier-schwin2020"
    friendly_name        = "Elsevier - SchWin2020"
    description          = "Elsevier - SchWin2020"
    path                 = "C:\\Progs\\Elsevier\\2020\\SchWin2020.lnk" 
    icon_path            = "c:\\Progs\\Elsevier\\IconFiles\\SchWin.exe"
    icon_index           = 0
  }
  
  module "avd-prd-dag_elsevier_schwin2019" {
    source               = "./modules/tf-azurerm-avd-da"
    application_group_id = module.avd-prd-dag_elsevier.dag_id
    name                 = "elsevier-schwin2019"
    friendly_name        = "Elsevier - SchWin2019"
    description          = "Elsevier - SchWin2019"
    path                 = "C:\\Progs\\Elsevier\\2019\\SchWin2019.lnk" 
    icon_path            = "c:\\Progs\\Elsevier\\IconFiles\\SchWin.exe"
    icon_index           = 0
  }
  
  module "avd-prd-dag_elsevier_schwin2018" {
    source               = "./modules/tf-azurerm-avd-da"
    application_group_id = module.avd-prd-dag_elsevier.dag_id
    name                 = "elsevier-schwin2018"
    friendly_name        = "Elsevier - SchWin2018"
    description          = "Elsevier - SchWin2018"
    path                 = "C:\\Progs\\Elsevier\\2018\\SchWin2018.lnk" 
    icon_path            = "c:\\Progs\\Elsevier\\IconFiles\\SchWin.exe"
    icon_index           = 0
  }
  
  module "avd-prd-dag_elsevier_schwin2017" {
    source               = "./modules/tf-azurerm-avd-da"
    application_group_id = module.avd-prd-dag_elsevier.dag_id
    name                 = "elsevier-schwin2017"
    friendly_name        = "Elsevier - SchWin2017"
    description          = "Elsevier - SchWin2017"
    path                 = "C:\\Progs\\Elsevier\\2017\\SchWin2017.lnk" 
    icon_path            = "c:\\Progs\\Elsevier\\IconFiles\\SchWin.exe"
    icon_index           = 0
  }
  
  module "avd-prd-dag_elsevier_schwin2016" {
    source               = "./modules/tf-azurerm-avd-da"
    application_group_id = module.avd-prd-dag_elsevier.dag_id
    name                 = "elsevier-schwin2016"
    friendly_name        = "Elsevier - SchWin2016"
    description          = "Elsevier - SchWin2016"
    path                 = "C:\\Progs\\Elsevier\\2016\\SchWin2016.lnk" 
    icon_path            = "c:\\Progs\\Elsevier\\IconFiles\\SchWin.exe"
    icon_index           = 0
  }

    module "avd-prd-dag_elsevier_tmwin2022" {
    source               = "./modules/tf-azurerm-avd-da"
    application_group_id = module.avd-prd-dag_elsevier.dag_id
    name                 = "elsevier-tmwin2022"
    friendly_name        = "Elsevier - TmWin2022"
    description          = "Elsevier - TmWin2022"
    path                 = "C:\\Progs\\Elsevier\\2022\\TmWin2022.lnk" 
    icon_path            = "c:\\Progs\\Elsevier\\IconFiles\\TmWin.exe"
    icon_index           = 0
  }
  
  
  module "avd-prd-dag_elsevier_tmwin2021" {
    source               = "./modules/tf-azurerm-avd-da"
    application_group_id = module.avd-prd-dag_elsevier.dag_id
    name                 = "elsevier-tmwin2021"
    friendly_name        = "Elsevier - TmWin2021"
    description          = "Elsevier - TmWin2021"
    path                 = "C:\\Progs\\Elsevier\\2021\\TmWin2021.lnk" 
    icon_path            = "c:\\Progs\\Elsevier\\IconFiles\\TmWin.exe"
    icon_index           = 0
  }
  
  module "avd-prd-dag_elsevier_tmwin2020" {
    source               = "./modules/tf-azurerm-avd-da"
    application_group_id = module.avd-prd-dag_elsevier.dag_id
    name                 = "elsevier-tmwin2020"
    friendly_name        = "Elsevier - TmWin2020"
    description          = "Elsevier - TmWin2020"
    path                 = "C:\\Progs\\Elsevier\\2020\\TmWin2020.lnk" 
    icon_path            = "c:\\Progs\\Elsevier\\IconFiles\\TmWin.exe"
    icon_index           = 0
  }
  
  module "avd-prd-dag_elsevier_tmwin2019" {
    source               = "./modules/tf-azurerm-avd-da"
    application_group_id = module.avd-prd-dag_elsevier.dag_id
    name                 = "elsevier-tmwin2019"
    friendly_name        = "Elsevier - TmWin2019"
    description          = "Elsevier - TmWin2019"
    path                 = "C:\\Progs\\Elsevier\\2019\\TmWin2019.lnk" 
    icon_path            = "c:\\Progs\\Elsevier\\IconFiles\\TmWin.exe"
    icon_index           = 0
  }
  
  module "avd-prd-dag_elsevier_tmwin2018" {
    source               = "./modules/tf-azurerm-avd-da"
    application_group_id = module.avd-prd-dag_elsevier.dag_id
    name                 = "elsevier-tmwin2018"
    friendly_name        = "Elsevier - TmWin2018"
    description          = "Elsevier - TmWin2018"
    path                 = "C:\\Progs\\Elsevier\\2018\\TmWin2018.lnk" 
    icon_path            = "c:\\Progs\\Elsevier\\IconFiles\\TmWin.exe"
    icon_index           = 0
  }
  
  module "avd-prd-dag_elsevier_tmwin2017" {
    source               = "./modules/tf-azurerm-avd-da"
    application_group_id = module.avd-prd-dag_elsevier.dag_id
    name                 = "elsevier-tmwin2017"
    friendly_name        = "Elsevier - TmWin2017"
    description          = "Elsevier - TmWin2017"
    path                 = "C:\\Progs\\Elsevier\\2017\\TmWin2017.lnk" 
    icon_path            = "c:\\Progs\\Elsevier\\IconFiles\\TmWin.exe"
    icon_index           = 0
  }
  
  module "avd-prd-dag_elsevier_tmwin2016" {
    source               = "./modules/tf-azurerm-avd-da"
    application_group_id = module.avd-prd-dag_elsevier.dag_id
    name                 = "elsevier-tmwin2016"
    friendly_name        = "Elsevier - TmWin2016"
    description          = "Elsevier - TmWin2016"
    path                 = "C:\\Progs\\Elsevier\\2016\\TmWin2016.lnk" 
    icon_path            = "c:\\Progs\\Elsevier\\IconFiles\\TmWin.exe"
    icon_index           = 0
  }
  
  

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-avd-prd-dag_elsevier" {
  application_group_id = module.avd-prd-dag_elsevier.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}

#########################################################
# AgroVision
#########################################################

module "avd-prd-dag_agrovision" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-prd.host_pool_id
  type           = "RemoteApp"
  name           = "vdag-agrovision-prd-${var.location_short}-${var.instance}"
  friendly_name  = "Agrovision"
  description    = "Agrovision"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-prd]
}

module "avd-prd-dag_agrovision_agrovision" {
  source               = "./modules/tf-azurerm-avd-da"
  application_group_id = module.avd-prd-dag_agrovision.dag_id
  name                 = "agrovision"
  friendly_name        = "Agrovision"
  description          = "Agrovision"
  path                 = "C:\\Progs\\Agrovision\\IBMS.exe.lnk" 
  icon_path            = "C:\\Progs\\Agrovision\\IBMS.exe"
  icon_index           = 0
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-avd-prd-dag_agrovision" {
  application_group_id = module.avd-prd-dag_agrovision.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}

#########################################################
# AccountView
#########################################################

module "avd-prd-dag_accountview" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-prd.host_pool_id
  type           = "RemoteApp"
  name           = "vdag-accountview-prd-${var.location_short}-${var.instance}"
  friendly_name  = "AccountView"
  description    = "AccountView"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-prd]
}

module "avd-prd-dag_accountview_accountview" {
  source               = "./modules/tf-azurerm-avd-da"
  application_group_id = module.avd-prd-dag_accountview.dag_id
  name                 = "accountview"
  friendly_name        = "AccountView"
  description          = "AccountView"
  path                 = "C:\\Progs\\AccountView\\avwin.exe.lnk" 
  icon_path            = "C:\\Progs\\AccountView\\avwin.exe"
  icon_index           = 0
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-avd-prd-dag_accountview" {
  application_group_id = module.avd-prd-dag_accountview.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}

#########################################################
# ComponentAgro
#########################################################

module "avd-prd-dag_componentagro" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-prd.host_pool_id
  type           = "RemoteApp"
  name           = "vdag-componentagro-prd-${var.location_short}-${var.instance}"
  friendly_name  = "ComponentAgro"
  description    = "ComponentAgro"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-prd]
}

module "avd-prd-dag_componentagro_componentagro" {
  source               = "./modules/tf-azurerm-avd-da"
  application_group_id = module.avd-prd-dag_componentagro.dag_id
  name                 = "componentagro"
  friendly_name        = "ComponentAgro"
  description          = "ComponentAgro"
  path                 = "C:\\Progs\\ComponentAgro\\SSLoader.exe.lnk" 
  icon_path            = "C:\\Progs\\ComponentAgro\\SSLoader.exe"
  icon_index           = 0
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-avd-prd-dag_componentagro" {
  application_group_id = module.avd-prd-dag_componentagro.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}

#########################################################
# SDU Belasting Office
#########################################################

module "avd-prd-dag_sdu" {
  source         = "./modules/tf-azurerm-avd-dag"
  resource_group = azurerm_resource_group.rg.name
  location       = azurerm_resource_group.rg.location
  host_pool_id   = module.avd-hostpool-prd.host_pool_id
  type           = "RemoteApp"
  name           = "vdag-sdu-prd-${var.location_short}-${var.instance}"
  friendly_name  = "SDU"
  description    = "SDU"
  nlcnumber      = local.nlcnumber
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  depends_on     = [module.avd-hostpool-prd]
}
module "avd-prd-dag_sdu_sdu" {
  source               = "./modules/tf-azurerm-avd-da"
  application_group_id = module.avd-prd-dag_sdu.dag_id
  name                 = "SDU"
  friendly_name        = "SDU"
  description          = "SDU Belasting Office"
  path                 = "C:\\Program Files (x86)\\Sdu\\Belasting Office\\Bin\\sbo.exe"
  icon_path            = "C:\\Program Files (x86)\\Sdu\\Belasting Office\\Bin\\sbo.exe"
  icon_index           = 0
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspace-assoc-avd-prd-dag_sdu" {
  application_group_id = module.avd-prd-dag_sdu.dag_id
  workspace_id         = module.avd-workspace.workspace_id
}