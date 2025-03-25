##############################################
###      Defender definition updates       ###
##############################################
resource "time_offset" "this_day_dailyDefinitionUpdates" {
  offset_days = 1
  triggers = {
    changed_resource = local.dailyDefinitionUpdates_update_schedule_version
  }
}
locals {
  dailyDefinitionUpdates_update_schedule_version = "1.5" # Update this value when update schedule json is changed!!
  dailyDefinitionUpdates_update_time             = "T20:00:00+01:00"
}


# Standard Production Windows Servers Update schedule
resource "azurerm_resource_group_template_deployment" "deploy_dailyDefinitionUpdates_update_schedule" {
  name                = "DeploydailyWindowsDefinitionUpdatesSchedule"
  resource_group_name = azurerm_resource_group.rg-shared.name
  deployment_mode     = "Incremental"
  tags = {
    "Deployment type" = "Terraform"
    "Management type" = "Terraform"
  }

  template_content = <<DEPLOY
{
  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Automation/automationAccounts/softwareUpdateConfigurations",
      "apiVersion": "2017-05-15-preview",
      "name": "${azurerm_automation_account.aa-shared.name}/Daily Windows Definition Update",
      "properties": {
        "updateConfiguration": {
          "operatingSystem": "Windows",
            "windows": {
              "includedUpdateClassifications": "Definition",
              "rebootSetting": "Never"
            },
            "duration": "PT1H",
            "targets": {
              "azureQueries": [
                {
                  "scope": ["${data.azurerm_subscription.current.id}"],
                  "tagSettings": {
                                    "tags": {
                                      "OsType": [
                                        "Windows"
                                      ]
                                    },
                                    "filterOperator": "All"
                                },
                  "locations": ["westeurope"]
                }
              ]
            }
        },
        "scheduleInfo": {
          "startTime": "${substr(time_offset.this_day_dailyDefinitionUpdates.rfc3339, 0, 10)}${local.dailyDefinitionUpdates_update_time}",
          "expiryTime": "9999-12-31T23:59:00+01:00",
          "isEnabled": "true",
          "interval": 1,
          "frequency": "Hour",
          "timeZone": "Europe/Amsterdam"
        }
      }
    }
  ]
}
DEPLOY
}

##############################################
###    Daily Windows Updates No Reboot     ###
##############################################
resource "time_offset" "this_day_daily" {
  offset_days = 1
  triggers = {
    changed_resource = local.daily_update_schedule_version
  }
}
locals {
  daily_update_schedule_version = "1.5" # Update this value when update schedule json is changed!!
  daily_update_time             = "T03:00:00+01:00"
}


# Standard Production Windows Servers Update schedule
resource "azurerm_resource_group_template_deployment" "deploy_daily_update_schedule" {
  name                = "DeployDailyWindowsUpdateSchedule"
  resource_group_name = azurerm_resource_group.rg-shared.name
  deployment_mode     = "Incremental"
  tags = {
    "Deployment type" = "Terraform"
    "Management type" = "Terraform"
  }

  template_content = <<DEPLOY
{
  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Automation/automationAccounts/softwareUpdateConfigurations",
      "apiVersion": "2017-05-15-preview",
      "name": "${azurerm_automation_account.aa-shared.name}/Daily Windows Update",
      "properties": {
        "updateConfiguration": {
          "operatingSystem": "Windows",
            "windows": {
              "includedUpdateClassifications": "Critical, Security, UpdateRollup, Definition, Updates",
              "rebootSetting": "Never"
            },
            "duration": "PT2H",
            "targets": {
              "azureQueries": [
                {
                  "scope": ["${data.azurerm_subscription.current.id}"],
                  "tagSettings": {
                                    "tags": {
                                        "OsType": [
                                            "Windows"
                                        ]
                                    },
                                    "filterOperator": "All"
                                },
                  "locations": ["westeurope"]
                }
              ]
            }
        },
        "scheduleInfo": {
          "startTime": "${substr(time_offset.this_day_daily.rfc3339, 0, 10)}${local.daily_update_time}",
          "expiryTime": "9999-12-31T23:59:00+01:00",
          "isEnabled": "true",
          "interval": 1,
          "frequency": "Day",
          "timeZone": "Europe/Amsterdam"
        }
      }
    }
  ]
}
DEPLOY
}

##############################################
###  Weekly Windows Updates 1 With Reboot  ###
##############################################
resource "time_offset" "this_day_weekly1" {
  offset_days = 1
  triggers = {
    changed_resource = local.weekly1_update_schedule_version
  }
}

locals {
  weekly1_update_schedule_version = "1.4" # Update this value when update schedule json is changed!!
  weekly1_update_time             = "T04:00:00+01:00"

}

# Standard Production Windows Servers Update schedule
resource "azurerm_resource_group_template_deployment" "deploy_weekly_update_1_schedule" {
  name                = "DeployweeklyWindowsUpdate1Schedule"
  resource_group_name = azurerm_resource_group.rg-shared.name
  deployment_mode     = "Incremental"
  tags = {
    "Deployment type" = "Terraform"
    "Management type" = "Terraform"
  }

  template_content = <<DEPLOY
{
  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Automation/automationAccounts/softwareUpdateConfigurations",
      "apiVersion": "2017-05-15-preview",
      "name": "${azurerm_automation_account.aa-shared.name}/Weekly Windows Update 1",
      "properties": {
        "updateConfiguration": {
          "operatingSystem": "Windows",
            "windows": {
              "includedUpdateClassifications": "Critical, Security, UpdateRollup, Definition, Updates",
              "rebootSetting": "IfRequired"
            },
            "duration": "PT2H",
            "targets": {
              "azureQueries": [
                {
                  "scope": ["${data.azurerm_subscription.current.id}"],
                  "tagSettings": {
                                    "tags": {
                                        "UpdateGroup": [
                                            "1"
                                        ],
                                        "OsType": [
                                          "Windows"
                                        ]
                                    },
                                    "filterOperator": "All"
                                },
                  "locations": ["westeurope"]
                }
              ]
            }
        },
        "scheduleInfo": {
          "startTime": "${substr(time_offset.this_day_weekly1.rfc3339, 0, 10)}${local.weekly1_update_time}",
          "expiryTime": "9999-12-31T23:59:00+01:00",
          "isEnabled": "true",
          "interval": 1,
          "frequency": "Week",
          "timeZone": "Europe/Amsterdam",
          "advancedSchedule": {
            "weekDays": [
                "Sunday"
              ]
          }
        }
      }
    }
  ]
}
DEPLOY
}

##############################################
###  Weekly Windows Updates 2 With Reboot  ###
##############################################
resource "time_offset" "this_day_weekly2" {
  offset_days = 1
  triggers = {
    changed_resource = local.weekly2_update_schedule_version
  }
}

locals {
  weekly2_update_schedule_version = "1.5" # Update this value when update schedule json is changed!!
  weekly2_update_time             = "T05:00:00+01:00"

}

# Standard Production Windows Servers Update schedule
resource "azurerm_resource_group_template_deployment" "deploy_weekly_update_2_schedule" {
  name                = "DeployweeklyWindowsUpdate2Schedule"
  resource_group_name = azurerm_resource_group.rg-shared.name
  deployment_mode     = "Incremental"
  tags = {
    "Deployment type" = "Terraform"
    "Management type" = "Terraform"
  }

  template_content = <<DEPLOY
{
  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Automation/automationAccounts/softwareUpdateConfigurations",
      "apiVersion": "2017-05-15-preview",
      "name": "${azurerm_automation_account.aa-shared.name}/Weekly Windows Update 2",
      "properties": {
        "updateConfiguration": {
          "operatingSystem": "Windows",
            "windows": {
              "includedUpdateClassifications": "Critical, Security, UpdateRollup, Definition, Updates",
              "rebootSetting": "IfRequired"
            },
            "duration": "PT2H",
            "targets": {
              "azureQueries": [
                {
                  "scope": ["${data.azurerm_subscription.current.id}"],
                  "tagSettings": {
                                    "tags": {
                                        "UpdateGroup": [
                                            "2"
                                        ],
                                        "OsType": [
                                          "Windows"
                                        ]
                                    },
                                    "filterOperator": "All"
                                },
                  "locations": ["westeurope"]
                }
              ]
            }
        },
        "scheduleInfo": {
          "startTime": "${substr(time_offset.this_day_weekly2.rfc3339, 0, 10)}${local.weekly2_update_time}",
          "expiryTime": "9999-12-31T23:59:00+01:00",
          "isEnabled": "true",
          "interval": 1,
          "frequency": "Week",
          "timeZone": "Europe/Amsterdam",
          "advancedSchedule": {
            "weekDays": [
                "Sunday"
              ]
          }
        }
      }
    }
  ]
}
DEPLOY
}
