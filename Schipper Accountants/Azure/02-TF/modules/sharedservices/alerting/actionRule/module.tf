resource "azapi_resource" "actionRuleNoActionGroups" {
  type      = "Microsoft.AlertsManagement/actionRules@2021-08-08"
  name      = "${var.nlcNumber}-UpdateMaintenanceWindow"
  location  = "Global"
  parent_id = var.parentResourceId
  body = jsonencode({
    properties = {
      actions = [
        {
          actionType = "RemoveAllActionGroups"
        }
      ]
      conditions = [
        {
          field    = "TargetResourceType"
          operator = "Equals"
          values = [
            "microsoft.compute/virtualmachines"
          ]
        }
      ],
      description = "Disable action groups daily between ${var.startTime} and ${var.endTime}"
      enabled     = true
      schedule = {
        effectiveFrom = "2023-01-03T00:00:00"
        timeZone      = "W. Europe Standard Time"
        recurrences = [
          {
            recurrenceType = "Daily"
            startTime      = "${var.startTime}"
            endTime        = "${var.endTime}"
          }
        ]
      },
      scopes = "${var.scopes}"
    }
  })
}

resource "azapi_resource" "developmentActionRule" {
  count     = var.deploy_dev_action_rule == true ? 1 : 0
  type      = "Microsoft.AlertsManagement/actionRules@2021-08-08"
  name      = "${var.nlcNumber}-AlwaysSuppressActionGroups"
  location  = "Global"
  parent_id = var.parentResourceId
  body = jsonencode({
    properties = {
      actions = [
        {
          actionType = "RemoveAllActionGroups"
        }
      ]
      conditions = [
        {
          field    = "TargetResourceType"
          operator = "Equals"
          values = [
            "microsoft.compute/virtualmachines"
          ]
        }
      ],
      description = "Disable action groups 24/7 for development purposes"
      enabled     = true
      scopes = "${var.scopes}"
    }
  })
}