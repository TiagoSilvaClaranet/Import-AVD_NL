variable "location" {
  type = string
}

variable "resource-group-name" {
  type = string
}

variable "nsgs" {
  description = ""
  # type = map(map(string))
}

variable "tags" {
  type = map
}
