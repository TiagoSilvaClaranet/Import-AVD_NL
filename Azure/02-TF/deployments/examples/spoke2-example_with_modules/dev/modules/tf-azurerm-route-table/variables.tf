//Required Variables
variable "resource-group-name" {
  type = string
}
variable routes {}

variable route_tables {}

variable "location" {
  type = string
}
//Override Variables
variable "tags" {
  type = map(string)
  default = {
    "terraform" = "true"
  }
}
