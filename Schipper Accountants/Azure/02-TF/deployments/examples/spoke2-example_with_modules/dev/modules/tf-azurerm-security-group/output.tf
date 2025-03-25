output nsg_map {
  value = {
    for nsg in azurerm_network_security_group.nsg :
    nsg.name => nsg.id
  }
}
