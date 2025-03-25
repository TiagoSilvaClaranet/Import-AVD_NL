variable location {
  description = "The region in which to create resources"
  type        = string
  default     = "West Europe"
}

variable nlcnumber {
  description = "The messina number of the customer"
  type        = string
}

variable snet_prefix {
  description = "Subnet prefix"
  type        = list
}

variable "resourcesuffix" {
  description = "Suffix to append to resource names"
  type        = string
  default     = "001"
}

variable environment {
  description = "Environment (Production/Test/Acceptance/Development)"
  type        = string
}

variable "trusted_spoke_vnet"{
  description = "Trusted VNETs for inbound security rule"
  default     = null
  type        = list
}

variable "route_table_id" {
  description = "ID of the route table to connect to the shared resources subnet"
  default     = ""
}