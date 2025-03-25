# Collect data for Azure roles
data "azurerm_role_definition" "Desktop-Virtualization-Power-On-Off-Contributor" {
  name = "Desktop Virtualization Power On Off Contributor"
}

# Data collect from Windows Virtual Desktop (service principal)
data "azuread_service_principal" "windows-virtual-desktop" {
  display_name = "Windows Virtual Desktop"
}

resource "azurerm_role_assignment" "avd-role-assignment" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = data.azurerm_role_definition.Desktop-Virtualization-Power-On-Off-Contributor.name
  principal_id         = data.azuread_service_principal.windows-virtual-desktop.id
}

# Scaling Plans

  # Create Scaling Plan for Production pools (PRD)
  resource "azurerm_virtual_desktop_scaling_plan" "avd-scalingplan-prd" {
    name                = "avd-scalingplan-prd"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    friendly_name       = "AVD Scaling Plan PRD"
    description         = "AVD Scaling Plan for PRD host pool"
    time_zone           = "W. Europe Standard Time"
    exclusion_tag       = "Maintenance"
    schedule {
      name                                 = "Weekdays"
      days_of_week                         = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
      ramp_up_start_time                   = "07:00"
      ramp_up_load_balancing_algorithm     = "BreadthFirst"
      ramp_up_minimum_hosts_percent        = 20
      ramp_up_capacity_threshold_percent   = 60
      peak_start_time                      = "08:00"
      peak_load_balancing_algorithm        = "BreadthFirst"
      ramp_down_start_time                 = "18:00"
      ramp_down_load_balancing_algorithm   = "DepthFirst"
      ramp_down_minimum_hosts_percent      = 10
      ramp_down_force_logoff_users         = false
      ramp_down_wait_time_minutes          = 45
      ramp_down_notification_message       = "Please log off in the next 45 minutes..."
      ramp_down_capacity_threshold_percent = 5
      ramp_down_stop_hosts_when            = "ZeroSessions"
      off_peak_start_time                  = "20:00"
      off_peak_load_balancing_algorithm    = "DepthFirst"
    }
    host_pool {
      hostpool_id          = module.avd-hostpool-prd.host_pool_id
      scaling_plan_enabled = true
    }
  }

  # Create Scaling Plan for Acceptation pools (UAT)
  resource "azurerm_virtual_desktop_scaling_plan" "avd-scalingplan-uat" {
    name                = "avd-scalingplan-uat"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    friendly_name       = "AVD Scaling Plan UAT"
    description         = "AVD Scaling Plan for UAT host pool"
    time_zone           = "W. Europe Standard Time"
    exclusion_tag       = "Maintenance"
    schedule {
      name                                 = "Weekdays"
      days_of_week                         = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
      ramp_up_start_time                   = "07:00"
      ramp_up_load_balancing_algorithm     = "BreadthFirst"
      ramp_up_minimum_hosts_percent        = 20
      ramp_up_capacity_threshold_percent   = 60
      peak_start_time                      = "08:00"
      peak_load_balancing_algorithm        = "BreadthFirst"
      ramp_down_start_time                 = "18:00"
      ramp_down_load_balancing_algorithm   = "DepthFirst"
      ramp_down_minimum_hosts_percent      = 10
      ramp_down_force_logoff_users         = false
      ramp_down_wait_time_minutes          = 45
      ramp_down_notification_message       = "Please log off in the next 45 minutes..."
      ramp_down_capacity_threshold_percent = 5
      ramp_down_stop_hosts_when            = "ZeroSessions"
      off_peak_start_time                  = "20:00"
      off_peak_load_balancing_algorithm    = "DepthFirst"
    }
    host_pool {
      hostpool_id          = module.avd-hostpool-uat.host_pool_id
      scaling_plan_enabled = true
    }
  }

  # Create Scaling Plan for Development pools (DEV)
  resource "azurerm_virtual_desktop_scaling_plan" "avd-scalingplan-dev" {
    name                = "avd-scalingplan-dev"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    friendly_name       = "AVD Scaling Plan DEV"
    description         = "AVD Scaling Plan for DEV host pool"
    time_zone           = "W. Europe Standard Time"
    exclusion_tag       = "Maintenance"
    schedule {
      name                                 = "Weekdays"
      days_of_week                         = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
      ramp_up_start_time                   = "07:00"
      ramp_up_load_balancing_algorithm     = "BreadthFirst"
      ramp_up_minimum_hosts_percent        = 0
      ramp_up_capacity_threshold_percent   = 60
      peak_start_time                      = "08:00"
      peak_load_balancing_algorithm        = "BreadthFirst"
      ramp_down_start_time                 = "18:00"
      ramp_down_load_balancing_algorithm   = "DepthFirst"
      ramp_down_minimum_hosts_percent      = 0
      ramp_down_force_logoff_users         = false
      ramp_down_wait_time_minutes          = 45
      ramp_down_notification_message       = "Please log off in the next 45 minutes..."
      ramp_down_capacity_threshold_percent = 5
      ramp_down_stop_hosts_when            = "ZeroSessions"
      off_peak_start_time                  = "20:00"
      off_peak_load_balancing_algorithm    = "DepthFirst"
    }
    host_pool {
      hostpool_id          = module.avd-hostpool-dev.host_pool_id
      scaling_plan_enabled = true
    }
  }

  # Create Scaling Plan for Test pools (TST)
  resource "azurerm_virtual_desktop_scaling_plan" "avd-scalingplan-tst" {
    name                = "avd-scalingplan-tst"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    friendly_name       = "AVD Scaling Plan TST"
    description         = "AVD Scaling Plan for TST host pool"
    time_zone           = "W. Europe Standard Time"
    exclusion_tag       = "Maintenance"
    schedule {
      name                                 = "Weekdays"
      days_of_week                         = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
      ramp_up_start_time                   = "07:00"
      ramp_up_load_balancing_algorithm     = "BreadthFirst"
      ramp_up_minimum_hosts_percent        = 0
      ramp_up_capacity_threshold_percent   = 60
      peak_start_time                      = "08:00"
      peak_load_balancing_algorithm        = "BreadthFirst"
      ramp_down_start_time                 = "18:00"
      ramp_down_load_balancing_algorithm   = "DepthFirst"
      ramp_down_minimum_hosts_percent      = 0
      ramp_down_force_logoff_users         = false
      ramp_down_wait_time_minutes          = 45
      ramp_down_notification_message       = "Please log off in the next 45 minutes..."
      ramp_down_capacity_threshold_percent = 5
      ramp_down_stop_hosts_when            = "ZeroSessions"
      off_peak_start_time                  = "20:00"
      off_peak_load_balancing_algorithm    = "DepthFirst"
    }
    host_pool {
      hostpool_id          = module.avd-hostpool-tst.host_pool_id
      scaling_plan_enabled = true
    }
  }


/*
AVD Scaling Plan diagnostics
- Autoscale logs
*/

resource "azurerm_monitor_diagnostic_setting" "avd-scalingplan-diag-tst" {
  name                       = "AVD - Diagnostics"
  #name                      = "diag-fd-${var.solution}${var.prefix}-avd"
  #target_resource_id        = azurerm_virtual_desktop_application_group.fd.id 
  target_resource_id         = azurerm_virtual_desktop_scaling_plan.avd-scalingplan-tst.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  
  log {
    category = "Autoscale"
    enabled = "true"

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "avd-scalingplan-diag-dev" {
  name                       = "AVD - Diagnostics"
  #name                      = "diag-fd-${var.solution}${var.prefix}-avd"
  #target_resource_id        = azurerm_virtual_desktop_application_group.fd.id 
  target_resource_id         = azurerm_virtual_desktop_scaling_plan.avd-scalingplan-dev.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  
  log {
    category = "Autoscale"
    enabled = "true"

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "avd-scalingplan-diag-uat" {
  name                       = "AVD - Diagnostics"
  #name                      = "diag-fd-${var.solution}${var.prefix}-avd"
  #target_resource_id        = azurerm_virtual_desktop_application_group.fd.id 
  target_resource_id         = azurerm_virtual_desktop_scaling_plan.avd-scalingplan-uat.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  
  log {
    category = "Autoscale"
    enabled = "true"

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "avd-scalingplan-diag-prd" {
  name                       = "AVD - Diagnostics"
  #name                      = "diag-fd-${var.solution}${var.prefix}-avd"
  #target_resource_id        = azurerm_virtual_desktop_application_group.fd.id 
  target_resource_id         = azurerm_virtual_desktop_scaling_plan.avd-scalingplan-prd.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws-avd.id 
  
  log {
    category = "Autoscale"
    enabled = "true"

    retention_policy {
      enabled = false
    }
  }
}