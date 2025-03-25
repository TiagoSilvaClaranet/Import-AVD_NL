variable "customer_name" {
  type        = string
  description = "Customer name"
}
variable "short_customer_name" {
  type        = string
  description = "Short customer name (only lowercase and no special characters)"
}

variable "location" {
  type        = string
  description = "Location to deploy resources to"
  default     = "West Europe"
}

variable "service_principal_id" {
  description = "Supply the service principal object id that need read permissions on the management groups"
  type        = string
}

variable "monitoring-dcr-windows" {
  type        = string
  description = "Resource ID of the Windows DCR for monitoring"
  default     = "00000000-0000-0000-0000-00000000"
}

variable "monitoring-dcr-windowslogs-10x5" {
  type        = string
  description = "Resource ID of the Windows logs DCR for monitoring"
  default     = "00000000-0000-0000-0000-00000000"
}

variable "monitoring-dcr-windowslogs-24x7" {
  type        = string
  description = "Resource ID of the Windows logs DCR for monitoring"
  default     = "00000000-0000-0000-0000-00000000"
}

variable "monitoring-dcr-linuxlogs-10x5" {
  type        = string
  description = "Resource ID of the Linux logs DCR for monitoring"
  default     = "00000000-0000-0000-0000-00000000"
}

variable "monitoring-dcr-linuxlogs-24x7" {
  type        = string
  description = "Resource ID of the Linux logs DCR for monitoring"
  default     = "00000000-0000-0000-0000-00000000"
}

variable "monitoring-dcr-linux" {
  type        = string
  description = "Resource ID of the Windows DCR for monitoring"
  default     = "00000000-0000-0000-0000-00000000"
}

variable "monitoring-dcr-vminsights" {
  type        = string
  description = "Resource ID of the VMInsights DCR for monitoring"
  default     = "00000000-0000-0000-0000-00000000"
}

variable "monitoring-law" {
  type        = string
  description = "Resource ID of the Shared log analytics workspace"
  default     = "Dummy"
}
