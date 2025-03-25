variable "actionGroupResourceId" {
    type = string
    description = "Supply the resource id of the action group"
}

variable "pagerDutyActionGroupResourceId" {
    type = string
}

variable "logAnalyticsWorkspaceResourceId10x5" {
    type = string
    description = "Supply the resource id of the Log Analytics Workspace"
}

variable "logAnalyticsWorkspaceResourceId24x7" {
    type = string
    description = "Supply the resource id of the Log Analytics Workspace"
}

variable parentResourceId {
  type        = string
  description = "Supply the resource id of the resource group you want to store the alerts"
}

variable nlcNumber {
  description = "The messina number of the customer"
  type        = string
}
