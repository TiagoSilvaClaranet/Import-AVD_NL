variable location {
  description = "The region in which to create resources"
  type        = string
  default     = "West Europe"
}

variable location_short {
  description = "The region in which to create resources"
  type        = string
  default     = "weu"
}

variable nlcnumber {
  description = "The messina number of the customer"
  type        = string
}

variable resourcesuffix {
  description = "Suffix to append to resource names"
  type        = string
  default     = "001"
}


variable enable_update_management {
  description   = "Set to true to enable Update Management"
  type          = bool
  default       = false
}

variable enable_change_tracking {
  description   = "Set to true to enable Change Tracking"
  type          = bool
  default       = false
}

variable enable_alerting {
  description   = "Set to true to enable alerting"
  type          = bool
  default       = false
}

variable "deploy_dev_action_rule" {
  type = bool
  description = "When this is set to true, a action rule (processing rule) will be deployed that removes action groups 24/7"
}


variable "recoveryservicesvault_storage_mode" {
  description = "The storage mode of the recovery services vault. Possible values are: LocallyRedundant, GeoRedundant"
  type        = string 
  default     = "LocallyRedundant" // GeoRedundant
}

variable "environment" {
  description = "Environment name"
  type = string
  default = "prod"
}

variable "common_tags" {
  description = "Common tags to add to resources"
  type = map(string)
  default = {
    "Deployment type"   = "Terraform"
    "Management type"   = "Terraform"
  }
}

variable "keyvault_user_object_ids" {
  description = "Supply the user object id's that need access permissions on the keyvault"
  type = list(string)
}

variable "keyvault_service_principal_ids" {
  description = "Supply the service principal object id's that need access permissions on the keyvault"
  type = list(string)
}
