//Required Variables
variable "resource-group-name" {
  type = string
}
variable "vnets" {
  type = list(object({
    name    = string
    cidr    = list(string)
    dns     = list(string)
    ddos_id = string
  }))
}
variable "location" {
  type = string
}
variable "environment" {
  type = string
}

//Override Variables
variable "tags" {
  type = map(string)
  default = {
    "terraform" = "true"
  }
}
variable "log-analytics-resource-id" {
  type    = string
  default = ""
}
variable "diagnostics-retention-policy" {
  type    = string
  default = false
}
variable "metrics-retention-policy" {
  type    = string
  default = false
}
