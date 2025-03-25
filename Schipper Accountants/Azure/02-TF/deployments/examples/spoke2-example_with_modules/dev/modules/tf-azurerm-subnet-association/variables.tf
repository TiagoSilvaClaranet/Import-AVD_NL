variable subnet_map {
  type = map(string)
  default = {}
}

variable nsg_map {
  type = map(string)
  default = {}
}

variable route_table_map {
  type = map(string)
  default = {}
}

variable subnet_udrs {
  type = map(string)
  default = {}
}

variable subnet_nsgs {
  type = map(string)
  default = {}
}

