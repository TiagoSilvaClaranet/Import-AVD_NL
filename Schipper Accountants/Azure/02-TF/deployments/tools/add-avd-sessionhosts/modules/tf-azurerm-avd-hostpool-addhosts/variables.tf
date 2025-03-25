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

variable "avd_host_pool_id" {
  type        = string
  description = "ID of the host pool to add the session hosts to"
}

variable "avd_host_pool_name" {
  type = string
  description = "Name of the host pool to add the session hosts to"
}

variable "location" {

}

variable "resource_group" {}
variable "subnet_id" {}
variable "nlcnumber" {}

variable "vm_size" {
  default = "Standard_B2s"
}

variable "avd_ou_path" {
  type        = string
  description = "OU path used to AADDS domain-join AVD session hosts."
  default     = ""
}

variable "avd_register_session_host_modules_url" {
  type        = string
  description = "URL to .zip file containing DSC configuration to register AVD session hosts to AVD host pool."
  default     = "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_02-23-2022.zip"
}

variable "prefix" {
  type        = string
  default     = "AVD"
  description = "Prefix of the name of the AVD machine(s)"
}
variable "vmprefix" {
  type        = string
  default     = "vdsh"
  description = "Prefix of the computer name of the AVD machine(s)"
}

variable "local_admin_username" {
  type        = string
  description = "Name of the local administrator"
  default     = "cladmin"
}

#variable "avd_registration_token" {
#  type        = string
#  description = "Registration token to add session hosts to the Host Pool"
#}



variable "domain_name" {
  type        = string
  default     = "infra.local"
  description = "Name of the domain to join"
}
variable "domain_user_upn" {
  type        = string
  default     = "domainjoineruser" # do not include domain name as this is appended
  description = "Username for domain join (do not include domain name as this is appended)"
}
variable "domain_user_password" {
  description = "Password of the user to authenticate with the domain"
  sensitive   = true
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


variable "image_publisher" {
  description = "Image Publisher"
  default = "MicrosoftWindowsDesktop"
}

variable "image_offer" {
  description = "Image Offer"
  default = "Windows-11"
}

variable "image_sku" {
  description = "Image SKU"
  default = "win11-22h2-avd"
}

variable "image_version" {
  description = "Image Version"
  default = "latest"
}

variable "storage_account_type" {
  type = string
  description = "Type of storage to use for session hosts. Default is Premium_LRS"
  default = "Premium_LRS"
 }

variable "source_image_id" {
  type = string
  description = "ID of the image to use for VM deployment"
  default = null
 }

variable "enable_diagnostics" { 
  type = bool
  description = "Enable diagnostics logging to a log analytics workspace"
  default = true
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "ID of the Log Analytics Workspace to send diagnostics data. (Don't use the resource ID of the LAW!)"
  default     = null
}

variable "log_analytics_workspace_key" {
  type        = string
  description = "Key of the Log Analytics Workspace to send diagnostics data"
  default     = null
}

variable "used_image" {
    type = string
    default   = null
}

variable "enable_dcr" { 
  type = bool
  description = "Enable DCR association"
  default = true
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