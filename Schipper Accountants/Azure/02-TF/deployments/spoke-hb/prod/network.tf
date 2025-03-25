# RG
# Create a resource group
resource "azurerm_resource_group" "rg-spoke-hb-network" {
  #name     = "rg-spoke-${lower(var.deployment)}-network-${var.environment}-${var.location_short}-${var.instance}"
  name     = local.network_resource_group_name
  location = var.location
  tags     = merge(local.common_tags, {})
}

# VNET
# Create a virtual network within the resource group
resource "azurerm_virtual_network" "spoke_vnet1" {
  #name                = "vnet-spoke-${var.environment}-${var.location_short}-${var.instance}"
  name                = local.vnetname
  resource_group_name = azurerm_resource_group.rg-spoke-hb-network.name
  location            = azurerm_resource_group.rg-spoke-hb-network.location
  address_space       = ["10.252.29.0/24"]
  #dns_servers         = ["168.63.129.16"]
  dns_servers = ["10.252.17.20", "10.252.17.21"]
  tags        = merge(local.common_tags, {})
}

# SNET
# Create subnets
resource "azurerm_subnet" "snet-hb" {
  name                 = "snet-hb"
  resource_group_name  = azurerm_virtual_network.spoke_vnet1.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke_vnet1.name
  address_prefixes     = ["10.252.29.0/26"]
}

resource "azurerm_subnet" "snet-hb_dmz" {
  name                 = "snet-hb_dmz"
  resource_group_name  = azurerm_virtual_network.spoke_vnet1.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke_vnet1.name
  address_prefixes     = ["10.252.29.64/26"]
}

resource "azurerm_subnet" "snet-hb_avd" {
  name                 = "snet-hb_avd"
  resource_group_name  = azurerm_virtual_network.spoke_vnet1.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke_vnet1.name
  address_prefixes     = ["10.252.29.128/26"]
}

# For future use
# resource "azurerm_subnet" "snet-hb_free" {
#   name                 = "snet-hb_free"
#   resource_group_name  = azurerm_virtual_network.spoke_vnet1.resource_group_name
#   virtual_network_name = azurerm_virtual_network.spoke_vnet1.name
#   address_prefixes     = ["10.252.29.192/26"]
# }

# NSG
# Create Network Security Groups
resource "azurerm_network_security_group" "snet-hb-nsg" {
  name                = "snet-hb-nsg"
  resource_group_name = azurerm_resource_group.rg-spoke-hb-network.name
  location            = azurerm_resource_group.rg-spoke-hb-network.location
  /*
  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  */
  tags = merge(local.common_tags, {})
}

resource "azurerm_subnet_network_security_group_association" "snet-hb-nsg_assoc" {
  subnet_id                 = azurerm_subnet.snet-hb.id
  network_security_group_id = azurerm_network_security_group.snet-hb-nsg.id
}

resource "azurerm_network_security_group" "snet-hb_dmz-nsg" {
  name                = "snet-hb_dmz-nsg"
  resource_group_name = azurerm_resource_group.rg-spoke-hb-network.name
  location            = azurerm_resource_group.rg-spoke-hb-network.location

  tags = merge(local.common_tags, {})
}

resource "azurerm_subnet_network_security_group_association" "snet-hb_dmz-nsg_assoc" {
  subnet_id                 = azurerm_subnet.snet-hb_dmz.id
  network_security_group_id = azurerm_network_security_group.snet-hb_dmz-nsg.id
}

resource "azurerm_network_security_group" "snet-hb_avd-nsg" {
  name                = "snet-hb_avd-nsg"
  resource_group_name = azurerm_resource_group.rg-spoke-hb-network.name
  location            = azurerm_resource_group.rg-spoke-hb-network.location

  tags = merge(local.common_tags, {})
}

resource "azurerm_subnet_network_security_group_association" "snet-hb_avd-nsg_assoc" {
  subnet_id                 = azurerm_subnet.snet-hb_avd.id
  network_security_group_id = azurerm_network_security_group.snet-hb_avd-nsg.id
}

# RT
# Create route table for UDR to HUB's gateway
resource "azurerm_route_table" "route-use_hub_gateway" {
  name                          = "route-use_hub_gateway"
  resource_group_name           = azurerm_resource_group.rg-spoke-hb-network.name
  location                      = azurerm_resource_group.rg-spoke-hb-network.location
  disable_bgp_route_propagation = false

  route {
    name                   = "default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = local.hub_gateway_ip
  }

  tags = merge(local.common_tags, {})
}

# Associate route table to the subnets
resource "azurerm_subnet_route_table_association" "route-use_hub_gateway_assoc_snet-hb" {
  subnet_id      = azurerm_subnet.snet-hb.id
  route_table_id = azurerm_route_table.route-use_hub_gateway.id
}

resource "azurerm_subnet_route_table_association" "route-use_hub_gateway_assoc_snet-hb_dmz" {
  subnet_id      = azurerm_subnet.snet-hb_dmz.id
  route_table_id = azurerm_route_table.route-use_hub_gateway.id
}

resource "azurerm_subnet_route_table_association" "route-use_hub_gateway_assoc_snet-hb_avd" {
  subnet_id      = azurerm_subnet.snet-hb_avd.id
  route_table_id = azurerm_route_table.route-use_hub_gateway.id
}







