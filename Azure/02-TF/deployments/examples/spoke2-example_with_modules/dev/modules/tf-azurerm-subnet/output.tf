output subnet_map {
  value = {
    for subnet in azurerm_subnet.subnet :
    subnet.name => subnet.id
  }
}
