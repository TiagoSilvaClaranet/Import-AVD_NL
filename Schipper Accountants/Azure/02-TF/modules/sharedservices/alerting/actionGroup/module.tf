locals {
  resourceGroupName    = split("/", var.resourceGoupId)[4]
}

resource "azurerm_monitor_action_group" "mailActionGroup" {
  name                = "cbx-send-email"
  resource_group_name = local.resourceGroupName
  short_name          = "cbxnotify01"

  email_receiver {
    name                    = "SendToOperations"
    email_address           = var.operationsEmailAddress
    use_common_alert_schema = false
  }
}

resource "azurerm_monitor_action_group" "pagerDutyActionGroup" {
  name                = "cbx-pageDuty"
  resource_group_name = local.resourceGroupName
  short_name          = "cbxnotify02"

  webhook_receiver {
    name                    = var.dutyPager.name
    service_uri             = var.dutyPager.service_uri
    use_common_alert_schema = true
  }

}
