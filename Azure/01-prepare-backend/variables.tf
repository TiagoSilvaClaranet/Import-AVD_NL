variable location {
  description = "The region in which to create resources"
  type        = string
  default     = "West Europe"
}

variable location_short {
  description = "The region in which to create resources"
  type        = string
  default     = "weu"
}

variable nlcnumber {
  description = "The messina number of the customer"
  type        = string
}

variable resourcesuffix {
  description = "Suffix to be appended to the name of the resource"
  type        = string
  default     = "001"
}
