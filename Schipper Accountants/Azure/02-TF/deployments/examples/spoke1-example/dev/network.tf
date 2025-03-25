# Create a resource group
resource "azurerm_resource_group" "rg-spoke-network" {
  name     = "rg-${lower(var.deployment)}-network-${var.environment}-${var.location_short}-001"
  location = var.location
  tags     = local.common_tags
}
 
# Create a virtual network within the resource group
resource "azurerm_virtual_network" "spoke1_vnet1" {
  name                = "vnet-spoke1-${var.environment}-${var.location_short}-001"
  resource_group_name = azurerm_resource_group.rg-spoke-network.name
  location            = azurerm_resource_group.rg-spoke-network.location
  address_space       = ["10.252.222.0/24"]
  dns_servers         = ["168.63.129.16"]
  tags                = local.common_tags
}

# Create subnets
resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_virtual_network.spoke1_vnet1.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke1_vnet1.name
  address_prefixes     = ["10.252.222.0/28"]
}

resource "azurerm_subnet" "snet-subnet1" {
  name                 = "snet-subnet1"
  resource_group_name  = azurerm_virtual_network.spoke1_vnet1.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke1_vnet1.name
  address_prefixes     = ["10.252.222.16/28"]
}







