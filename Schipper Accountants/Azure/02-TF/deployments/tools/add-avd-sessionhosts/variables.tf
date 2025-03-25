variable "nlcnumber" {
  type        = string
  description = "Customer NLC Number"
}
variable "prefix" {
  type        = string
  description = "Prefix to use for the AVD resources"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Resource Group to deploy the Session Hosts resources in"
}

variable "avd_ou_path" {
  type        = string
  description = "OU path used to AADDS domain-join AVD session hosts." #"OU=AVD,OU=AAD,DC=contoso,DC=net"
  default     = ""
}

variable "avd_subnet_id" {
  type        = string
  description = "Subnet to place AVD session hosts in (full id/scope)"
}

variable "vm_size" {
  type        = string
  description = "Size of the VM sku to use"
  default     = "Standard_B2s"
}

variable "domain_name" {
  type        = string
  description = "Domain name to join the AVD session hosts"
}

variable "domain_user_upn" {
  type        = string
  description = "Username of the account to use for the domain join" # do not include domain name as this is appended
}

variable "domain_user_password" {
  type        = string
  description = "Password of the account to use for the domain join"
}

variable "storage_account_type" {
  type        = string
  description = "Type of storage to use for session hosts. Default is Premium_LRS"
  default     = "Premium_LRS"
}

variable "avd_host_pool_name" {
  type        = string
  description = "Name of the host pool to add the session hosts to"
}

variable "avd_host_pool_id" {
  type        = string
  description = "ID of the host pool to add the session hosts to"
}

#variable "avd_hostpool_registration_token" {
#  type        = string
#  description = "Registration token to add session hosts to the Host Pool"
#}

variable "avd_host_pool_size" {
  type        = number
  description = "Number of sessions hosts to add to the host pool"
  default     = 1
}

variable "avd_starting_offset" {
  type        = number
  description = "Starting offset to add to the Number of sessions hosts to add to the host pool"
  default     = 1
}

variable "source_image_id" {
  type        = string
  description = "ID of the image to use for VM deployment"
  default     = null
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of the Log Analytics Workspace to send diagnostics data. (Don't use the resource ID of the LAW!)"
  default     = null
}

variable "log_analytics_workspace_key" {
  type        = string
  description = "Key of the Log Analytics Workspace to send diagnostics data (Deprecated)"
  default     = "Key is automatically retrieved from keyvault"
}

variable "shared_keyvault_name" {
  type = string
  description = "Name of the keyvault to retrieve secrets from"
}

variable "shared_keyvault_rg" {
  type = string
  description = "Resource Group which contains the keyvault"
}

variable "dcr_id" {
  type        = string
  description = "Resource ID of the Data Collection Rule to associate"
  default     = null
}

variable "dcr-vmi_id" {
  type        = string
  description = "Resource ID of the VM Insights Data Collection Rule to associate"
  default     = null
}
