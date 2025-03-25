/*
Creates the following resources:
  1) Resource Group           : rg-sharedresources
  2) Subnet                   : snet-shared
  3) Network Security Group   : snet-shared-nsg
  4) Default NSG Rules

*/

##########################################
# Data objects
##########################################
data "azurerm_resource_group" "rg-network" {
    name = "rg-network-weu-${var.resourcesuffix}"
}

data "azurerm_virtual_network" "vnet1" {
    name = "vnet-prod-weu-${var.resourcesuffix}"
    resource_group_name = data.azurerm_resource_group.rg-network.name
}

##########################################
# Resource Group
##########################################
resource "azurerm_resource_group" "rg-sharedresources" {
  name     = "rg-sharedresources-weu-${var.resourcesuffix}"
  location = var.location
  
  tags = {
    "Deployment type"   = "Terraform"
    "Management type"   = "Terraform"
  }
}

##########################################
# Subnet
##########################################
resource "azurerm_subnet" "snet-shared" {
  name                 = "snet-shared"
  resource_group_name  = data.azurerm_resource_group.rg-network.name
  virtual_network_name = data.azurerm_virtual_network.vnet1.name
  address_prefixes     = var.snet_prefix
}


##########################################
# Associate route table to subnet if specified
##########################################
locals {
  dummy_route_table_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/routeTables/rt"
  perform_route_table_association = var.route_table_id != "" ? "true" : "false"
  route_table_id = var.route_table_id != "" ? var.route_table_id : local.dummy_route_table_id
}

resource "azurerm_subnet_route_table_association" "snet-shared-udr" {
  count = local.perform_route_table_association == "true" ? 1 : 0
  subnet_id      = azurerm_subnet.snet-shared.id
  route_table_id = local.route_table_id
}

##########################################
# Subnet Network Security Group
##########################################
resource "azurerm_network_security_group" "snet-shared-nsg" {
  name                = "snet-shared-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-sharedresources.name
  tags = {
    "Deployment type"   = "Terraform"
    "Management type"   = "Terraform"
  }
}
##########################################
# Subnet Network Security Group Association
##########################################
resource "azurerm_subnet_network_security_group_association" "snet-shared-nsg-assoc" {
  subnet_id                 = azurerm_subnet.snet-shared.id
  network_security_group_id = azurerm_network_security_group.snet-shared-nsg.id
}

##########################################
# Network Security Group Rules
##########################################
# Allow VnetInbound traffic only from own vnet and not from VPN remote ranges
resource "azurerm_network_security_rule" "AllowVnetOnlyInBound" {
   resource_group_name         = azurerm_resource_group.rg-sharedresources.name
   network_security_group_name = azurerm_network_security_group.snet-shared-nsg.name
   name                       = "AllowVnetOnlyInBound"
   priority                   = 4095
   direction                  = "Inbound"
   access                     = "Allow"
   protocol                   = "*"
   source_port_range          = "*"
   destination_port_range     = "*"
   source_address_prefixes    = var.trusted_spoke_vnet == null ? data.azurerm_virtual_network.vnet1.address_space : concat(var.trusted_spoke_vnet,data.azurerm_virtual_network.vnet1.address_space)
   destination_address_prefix = "*"
}
# Deny default VnetInbound traffic because it also contains all VPN traffic which we dont want te be whitelisted
resource "azurerm_network_security_rule" "DenyDefaultVnetInBound" {
   resource_group_name         = azurerm_resource_group.rg-sharedresources.name
   network_security_group_name = azurerm_network_security_group.snet-shared-nsg.name
   name                        = "DenyDefaultVnetInBound"
   priority                    = 4096
   direction                   = "Inbound"
   access                      = "Deny"
   protocol                    = "*"
   source_port_range           = "*"
   destination_port_range      = "*"
   source_address_prefix       = "VirtualNetwork"
   destination_address_prefix  = "VirtualNetwork"
}