variable "location" {
  description = "The region in which to create resources"
  type        = string
  default     = "West Europe"
}

variable "nlcnumber" {
  description = "The messina number of the customer"
  type        = string
}
variable "snet-mgmt_prefix" {
  description = "Prefix of snet-mgmt"
  type        = list(string)
}

variable "resourcesuffix" {
  description = "Suffix to append to resource names"
  type        = string
  default     = "001"
}

variable MGMT_IP {
  description = "MGMT IP"
  type        = string
}

variable MGMT_SLA {
  description = "MGMT SLA"
  type        = string
  default     = "8x5" 
}
variable MGMT_backuppolicy {
  description = "Backup Policy to be used"
  type        = string
  default     = "BackupDaily-30Days"
}
variable MGMT_product {
  description = "Product to be used"
  type        = string
  default     = "Public-Cloud-Light"
}
variable MGMT_status {
  description = "Status"
  type        = string
  default     = "Production"
}

variable "vmName" {
  description = "Name of the VM resource in Azure"
  type = string
  default = "MT01"  
}

variable "computerName" {
  description = "NETBIOS computer name of the VM"
  type = string
  default = "MT01"
}

variable "ignore_pip" {
  description = "Deploy PIP switch (on/off)"
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Common tags to add to resources"
  type        = map(string)
}

variable "image_sku" {
  type        = string
  description = "VM Image SKU to use"
  default     = "2022-Datacenter"
}

variable "route_table_id" {
  description = "ID of the route table to connect to the management subnet"
  default     = ""
}

variable "rdp_whitelist_ips" {
  description =  "Additional IP numbers to whitelist for RDP"
  default     = []
  type        = list
}
