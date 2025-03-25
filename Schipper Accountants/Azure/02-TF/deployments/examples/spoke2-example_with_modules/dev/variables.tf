variable location {
  description = "The region in which to create resources"
  type        = string
  default     = "West Europe"
}
variable location_short {
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

variable "hub_gateway_ip" {
  description = "The IP address of the hub gateway"
  type        = string
}


variable vnets {}
variable "log-analytics-resource-id" {
  type    = string
  default = ""
}

variable subnets {}
variable nsgs {}

variable routes {}
variable route_tables {}


variable subnet_udrs {}
variable subnet_nsgs {}


/*
variable nlcnumber {
  description = "The messina number of the customer"
  type        = string
}

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