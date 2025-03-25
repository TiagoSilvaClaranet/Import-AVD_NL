variable "location" {
  description = "The region in which to create resources"
  type        = string
  default     = "West Europe"
}
variable "location_short" {
  description = "Short name of the region in which to create resources"
  type        = string
  default     = "weu"
}

variable "environment" {
  description = "The environment to deploy to"
  type        = string
  default     = "dev" #prod, uat, dev, sandbox
}

variable "deployment" {
  description = "The name to be used to identity the deployment"
  type        = string
}

variable "instance" {
  type        = string
  description = "Instance number"
  default     = "001"
}

variable "nlcnumber" {
  description = "The messina number of the customer"
  type        = string
}

/*
variable "spoke_vnet_address_space" {
  description = "Vnet address space"
  type        = list(string)
}

variable "spoke_vnet_dns_servers" {
  description = "DNS servers to be used in VNET"
  type        = list(string)
}
variable "spoke_vnet_gateway_subnet_prefix" {
  description = "Gateway Subnet prefix"
  type        = list(string)
}
*/