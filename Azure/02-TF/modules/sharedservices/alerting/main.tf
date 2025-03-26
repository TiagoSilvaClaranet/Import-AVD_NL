data "azurerm_subscription" "current" {
}

module "actionGroup" {
  source = "./actionGroup"

  resourceGoupId = var.parentResourceId
}

module "actionRule" {
  source = "./actionRule"

  parentResourceId = var.parentResourceId
  scopes           = ["${var.subscriptionId}"]
  nlcNumber        = var.nlcnumber
  deploy_dev_action_rule = var.deploy_dev_action_rule
}

module "vmLogAlerts" {
  source = "./vmLogAlerts"

  parentResourceId                    = var.parentResourceId
  actionGroupResourceId               = module.actionGroup.mailActionGroupResourceId
  pagerDutyActionGroupResourceId      = module.actionGroup.pagerDutyActionGroupResourceId
  logAnalyticsWorkspaceResourceId10x5  = var.logAnalyticsWorkspaceResourceId10x5
  logAnalyticsWorkspaceResourceId24x7 = var.logAnalyticsWorkspaceResourceId24x7
  nlcNumber                           = var.nlcnumber
}

module "AzurePolicy-VmMetricAlerts" {
    source          = "./vmMetricAlerts"

    subscription_id                 = data.azurerm_subscription.current.id
    mailActionGroupResourceId       = module.actionGroup.mailActionGroupResourceId
    pagerDutyActionGroupResourceId  = module.actionGroup.pagerDutyActionGroupResourceId

}