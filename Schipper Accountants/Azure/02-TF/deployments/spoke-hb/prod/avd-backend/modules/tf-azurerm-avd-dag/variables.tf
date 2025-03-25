variable "resource_group" {
  
}

variable "host_pool_id" {
  
}

variable "location" {
  
}

variable "type" {
  default = "Desktop"
}

variable "name" {
  
}

variable "default_desktop_display_name" {
  type = string
  description = "Display name of the desktop session"
  default = "Desktop"
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
  description = "Enable diagnostics loggin to a log analytics workspace"
  default = true
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of the Log Analytics Workspace to send diagnostics data (if ommited diagnostics settings wont be enabled)"
  default     = null
}



