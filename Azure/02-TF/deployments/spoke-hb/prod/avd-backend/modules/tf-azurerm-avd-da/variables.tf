variable "name" {
    type = string
    description = "Name of the application"
}
variable "friendly_name" {
    type = string
    description = "Friendly name of the application"
}

variable "application_group_id" {}

variable "description" {
    type = string
    description = "Application description"
}

variable "path" {
    type = string
    description = "Path of the executable"
}

variable "icon_path" {
    type = string
    description = "Path of the icon to use"
}

variable "icon_index" {
    type = number
    description = "Index of the icon to use"
    default = 0
}

variable "command_line_argument_policy" {
    type = string
    description = "Allow command line arguments set by the client (DoNotAllow/Allow/Require)"
    default = "DoNotAllow"
}
variable "command_line_arguments" {
    type = string
    description = "Command line arguments"
    default = ""
}

variable "show_in_portal" {
    type = bool
    description = "(Optional) Specifies whether to show the RemoteApp program in the RD Web Access server."
    default = "true"
}