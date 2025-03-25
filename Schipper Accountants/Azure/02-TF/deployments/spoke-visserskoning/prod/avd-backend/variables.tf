variable "spokename" {
  type        = string
  description = "Name of the spoke/deployment"
  default     = "customer"
}

variable "nlcnumber" {
  type        = string
  description = "NLC Number of the customer"
}

variable "location" {
  type        = string
  description = "Region to deploy resources in"
  default     = "westeurope"
}

variable "location_short" {
  type        = string
  description = "Short name of the region to deploy resources in"
  default     = "weu"
}

variable "environment" {
  type        = string
  description = "Name of the environment (dev/test/uat/prod)"
  default     = "prod"
}

variable "instance" {
  type        = string
  description = "Instance nr to append to the resources (Default is 001)"
  default     = "001"
}

variable "hostpool_name" {
  type = string
  description = "Name to identify the host pool"
  default = "generic"
}

variable "hostpool_name_short" {
  type = string
  description = "Short name (3 chars) to identify the host pool"
  default = ""
}

variable "sig_name" {
  type        = string
  description = "(optional) name to identify a SIG"
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

