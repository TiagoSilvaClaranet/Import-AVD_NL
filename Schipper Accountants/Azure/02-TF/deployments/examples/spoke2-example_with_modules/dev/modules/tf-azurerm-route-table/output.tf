output route_map {
  value = {
    for table in azurerm_route_table.route_table :
    table.name => table.id
  }
}
