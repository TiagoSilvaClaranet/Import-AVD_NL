variable location {
  description = "The region in which to create resources"
  type        = string
  default     = "West Europe"
}

variable nlcnumber {
  description = "The messina number of the customer"
  type        = string
}

variable "address_space" {
  description = "Vnet address space"
  type        = list(string)
}

variable "dns_servers" {
  description = "DNS servers to be used in VNET"
  type        = list(string)
}
variable "gateway_subnet_prefix" {
  description = "Gateway Subnet prefix"
  type        = list(string)
}

variable "resourcesuffix" {
  description = "Suffix to append to resource names"
  type        = string
  default     = "001"
}
variable "common_tags" {
  description = "Common tags to add to resources"
  type = map(string)
}

