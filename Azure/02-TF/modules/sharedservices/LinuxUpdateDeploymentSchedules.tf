##############################################
###     Daily Linux Updates No Reboot      ###
##############################################
resource "time_offset" "this_day_daily_linux" {
  offset_days = 1
  triggers = {
    changed_resource = local.daily_update_schedule_version_linux
  }
}
locals {
  daily_update_schedule_version_linux = "1.5" # Update this value when update schedule json is changed!!
  daily_update_time_linux             = "T03:00:00+01:00"
}


# Standard Production Linux Servers Update schedule
resource "azurerm_resource_group_template_deployment" "deploy_daily_update_schedule_linux" {
  name                = "DeployDailyLinuxUpdateSchedule"
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
      "name": "${azurerm_automation_account.aa-shared.name}/Linux Daily Update",
      "properties": {
        "updateConfiguration": {
          "operatingSystem": "Linux",
            "linux": {
              "includedPackageClassifications": "Critical, Security, Other",
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
                                            "Linux"
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
          "startTime": "${substr(time_offset.this_day_daily_linux.rfc3339, 0, 10)}${local.daily_update_time_linux}",
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
###   Weekly Linux Updates 1 With Reboot   ###
##############################################
resource "time_offset" "this_day_weekly1_linux" {
  offset_days = 1
  triggers = {
    changed_resource = local.weekly1_update_schedule_version_linux
  }
}

locals {
  weekly1_update_schedule_version_linux = "1.4" # Update this value when update schedule json is changed!!
  weekly1_update_time_linux       = "T04:00:00+01:00"

}

# Standard Production Linux Servers Update schedule
resource "azurerm_resource_group_template_deployment" "deploy_weekly_update_1_schedule_linux" {
  name                = "DeployweeklyLinuxUpdate1Schedule"
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
      "name": "${azurerm_automation_account.aa-shared.name}/Weekly Linux Update 1",
      "properties": {
        "updateConfiguration": {
          "operatingSystem": "Linux",
            "linux": {
              "includedPackageClassifications": "Critical, Security, Other",
              "rebootSetting": "Never"
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
                                          "Linux"
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
          "startTime": "${substr(time_offset.this_day_weekly1_linux.rfc3339, 0, 10)}${local.weekly1_update_time_linux}",
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
###   Weekly Linux Updates 2 With Reboot   ###
##############################################
resource "time_offset" "this_day_weekly2_linux" {
  offset_days = 1
  triggers = {
    changed_resource = local.weekly2_update_schedule_version_linux
  }
}

locals {
  weekly2_update_schedule_version_linux = "1.5" # Update this value when update schedule json is changed!!
  weekly2_update_time_linux       = "T05:00:00+01:00"

}

# Standard Production Linux Servers Update schedule
resource "azurerm_resource_group_template_deployment" "deploy_weekly_update_2_schedule_linux" {
  name                = "DeployweeklyLinuxUpdate2Schedule"
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
      "name": "${azurerm_automation_account.aa-shared.name}/Weekly Linux Update 2",
      "properties": {
        "updateConfiguration": {
          "operatingSystem": "Linux",
            "linux": {
              "includedPackageClassifications": "Critical, Security, Other",
              "rebootSetting": "Never"
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
                                          "Linux"
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
          "startTime": "${substr(time_offset.this_day_weekly2_linux.rfc3339, 0, 10)}${local.weekly2_update_time_linux}",
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
