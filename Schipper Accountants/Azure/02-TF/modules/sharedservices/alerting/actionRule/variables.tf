variable "scopes" {
  type = list(string)
  description = "Supply a list of resource id's to apply this actionRule"
}

variable "startTime" {
  type = string
  description = "Set the required start time for the maintenance window"
  default = "03:00:00"
}

variable "endTime" {
  type = string
  description = "Set the required end time for the maintenance window"
  default = "05:00:00"
}

variable nlcNumber {
  description = "The messina number of the customer"
  type        = string
}

variable "parentResourceId" {
  type = string
}

variable "deploy_dev_action_rule" {
  type = bool
  description = "When this is set to true, a action rule (processing rule) will be deployed that removes action groups 24/7"
} 