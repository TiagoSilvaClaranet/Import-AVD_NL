variable "location" {
  type        = string
  description = "Region to deploy resources in"
  default     = "westeurope"
}

variable "resource_group" {
  type = string
  description = "Resource Group to deploy resources in"
}

variable "name" {
  type = string
  description = "Name of the Host Pool"  
}

variable "friendly_name" {
  type = string
  description = "Friendly name of the Host Pool"  
}

variable "hostpool_name_short" {
  type = string
  description = "Short name (3 chars) to identify the host pool"
  default = ""
}

variable "description" {
  default = "AVD Host Pool"
}

variable "validate_environment" {
  type = bool
  default = false
}

variable "start_vm_on_connect" {
  type = bool
  default = true
}

variable "custom_rdp_properties" {
  type = string
  default = "enablerdsaadauth:i:1;" # By default we enable support for Azure AD authentication
}

variable "type" {
  description =  "Pooled or Personal (default is Pooled)"
  type = string
  default =  "Pooled"
}

variable "maximum_sessions_allowed" {
  default = 10
}

variable "load_balancer_type" {
    description = "Type load balance (BreadthFirst/DepthFirst/)"
    type=string
    default="BreadthFirst"
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
