variable "parentResourceId" {
  type = string
  description = "Supply the resource id of the resource group you want to deploy the alerts in"
}

variable "subscriptionId" {
  type = string
  description = "Supply the subscription id where to apply the action group and action rule"
}

variable "logAnalyticsWorkspaceResourceId10x5" {
  type = string
  description = "Supply the resource id of the shared log analytics workspace for 10x5 monitoring"
}

variable "logAnalyticsWorkspaceResourceId24x7" {
  type = string
  description = "Supply the resource id of the shared log analytics workspace for 24x7 monitoring"
}

variable "nlcnumber" {
  type = string
  description = "Supply the customer number"
}

variable "deploy_dev_action_rule" {
  type = bool
  description = "When this is set to true, a action rule (processing rule) will be deployed that removes action groups 24/7"
} 