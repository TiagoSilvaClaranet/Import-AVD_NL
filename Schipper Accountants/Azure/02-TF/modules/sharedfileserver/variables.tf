variable "resource_group" {
  description = "Name of the resource group to deploy the resource in"
  type = string
}
variable location {
  description = "The region in which to create resources"
  type        = string
  default     = "West Europe"
}

variable nlcnumber {
  description = "The messina number of the customer (used as prefix)"
  type        = string
}

variable "resourcesuffix" {
  description = "Suffix to append to resource names"
  type        = string
  default     = "001"
}

variable "servername" {
  description = "Name of the server"
  type        = string
  default     = "FS01"
}

variable "admin_username" {
  description = "Administrator username"
  type        = string
  default     = "cladmin"
}

variable "os_storage_type" {
  description = "Storage type for OS disk (Standard_LRS, StandardSSD_ZRS, Premium_LRS, Premium_ZRS, StandardSSD_LRS or UltraSSD_LRS)"
  type        = string
  default     = "Standard_LRS"
}

variable "DATA_storage_type" {
  description = "Storage type for DATA disks (Standard_LRS, StandardSSD_ZRS, Premium_LRS, Premium_ZRS, StandardSSD_LRS or UltraSSD_LRS)"
  type        = string
  default     = "Standard_LRS"
}

#variable environment {
#  description = "Environment (Production/Test/Acceptance/Development)"
#  type        = string
#}

variable fileserver_ip {
  description = "Fileserver IP"
  type        = string
}
variable fileserver_skusize {
  description = "SKU to be used"
  type        = string
  default     = "Standard_B2ms"
}

variable sharedfileserver_SLA {
  description = "Fileserver SLA"
  type        = string
  default     = "8x5" 
}

variable sharedfileserver_Billable {
  description = "Billing Type"
  type        = string
  default     = "Billable-Dynamic" 
}

variable sharedfileserver_backuppolicy {
  description = "Backup Policy to be used"
  type        = string
  default     = "BackupDaily-30Days"
}

variable sharedfileserver_product {
  description = "Product to be used"
  type        = string
  default     = "Public-Cloud-Light"
}
variable sharedfileserver_status {
  description = "Status"
  type        = string
  default     = "Production"
}
variable sharedfileserver_owner {
  description = "Owner of the server"
  type        = string
  default     = "Cloud"
}

variable data_disk1_size {
  description = "Size of the data disk"
  type        = string
}

variable os_caching {
  description = "Specifies the caching requirements for the OS Disk"
  type        = string
  default     = "ReadWrite"
}

## image

variable image_publisher {
  description = "Specifies the publisher of the image used to create the VM(s)"
  type        = string
  default     = "MicrosoftWindowsServer"
}

variable image_offer {
  description = "Specifies the offer of the image used to create the VM(s)"
  type        = string
  default     = "WindowsServer"
}

variable image_sku {
  description = "Specifies the SKU of the image used to create the VM(s)"
  type        = string
  default     = "2019-Datacenter"
}

variable image_version {
  description = "Specifies the version of the image used to create the VM(s)"
  type        = string
  default     = "latest"
}

variable "join_adds_domain_name" {
  description = "Domain name to join"
  type        = string
  default     = "adds.mydomain.nl"
}

variable "join_adds_username" {
  description = "Username of the account to use to join the domain"
  type        = string
  default     = "cladmin"
}
variable "join_adds_password" {
  description = "Password of the username of the account to use to join the domain"
  type        = string
  default     = ""
}

variable "common_tags" {
  description = "Common tags to add to resources"
  type = map(string)
  default = {
    "Deployment type"   = "Terraform"
    "Management type"   = "Terraform"
  }
}