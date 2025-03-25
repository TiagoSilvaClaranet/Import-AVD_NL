# Create a resource group
resource "azurerm_resource_group" "rg-network" {
  name     = "rg-network-weu-${var.resourcesuffix}"
  location = var.location
  tags     = var.common_tags
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet-prod-weu-${var.resourcesuffix}"
  resource_group_name = azurerm_resource_group.rg-network.name
  location            = azurerm_resource_group.rg-network.location
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = var.common_tags
}

# Create subnets
resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg-network.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = var.gateway_subnet_prefix
}

# Create Network Watcher (doing this cause otherwise Azure will create it by default with non governed naming)
# TODO When vnet is created a default Network Watcher is also created. This resources needs to be deleted first.
# There is a way to alter tenant settings to not create Network Watcher by default
resource "azurerm_network_watcher" "network-watcher" {
  name                = "nw-weu-${var.resourcesuffix}"
  location            = azurerm_resource_group.rg-network.location
  resource_group_name = azurerm_resource_group.rg-network.name
  tags                = var.common_tags
}


