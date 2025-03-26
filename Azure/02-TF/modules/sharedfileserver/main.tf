data "azurerm_resource_group" "rg-network" {
    name = "rg-network-weu-${var.resourcesuffix}"
}

data "azurerm_virtual_network" "vnet1" {
    name = "vnet-prod-weu-${var.resourcesuffix}"
    resource_group_name = data.azurerm_resource_group.rg-network.name
}

data "azurerm_resource_group" "rg-sharedresources" {
  name     = var.resource_group
}

data  "azurerm_subnet" "snet-shared" {
  name                 = "snet-shared"
  resource_group_name  = data.azurerm_resource_group.rg-network.name
  virtual_network_name = data.azurerm_virtual_network.vnet1.name
}
data "azurerm_network_security_group" "snet-shared-nsg"{
  name                = "snet-shared-nsg"
  resource_group_name = data.azurerm_resource_group.rg-sharedresources.name
}


