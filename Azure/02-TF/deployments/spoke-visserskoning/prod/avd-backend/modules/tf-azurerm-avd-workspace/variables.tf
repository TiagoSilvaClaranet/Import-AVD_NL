variable "name" {
  
}

variable "resource_group" {
  
}

variable "location" {
  default = "westeurope"
}

variable "friendly_name" {
  
}

variable "description" {
  
}

variable "common_tags" {
  description = "Common tags to add to resources"
  type = map(string)
  default = {
    "Deployment type"   = "Terraform"
    "Management type"   = "Terraform"
  }
}


variable "owner" {
    type = string
    default = "Cloud"
}

variable "nlcnumber" {
    type = string
  
}
variable "enable_diagnostics" { 
  type = bool
  description = "Enable diagnostics logging to a log analytics workspace"
  default = true
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of the Log Analytics Workspace to send diagnostics data (if ommited diagnostics settings wont be enabled)"
  default     = null
}