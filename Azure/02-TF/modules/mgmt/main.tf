locals {
  vmResourceName = "${var.nlcnumber}-${var.vmName}"
}

data "azurerm_resource_group" "rg-network" {
    name     = "rg-network-weu-${var.resourcesuffix}"
}

data "azurerm_virtual_network" "vnet1" {
    name = "vnet-prod-weu-${var.resourcesuffix}"
    resource_group_name = data.azurerm_resource_group.rg-network.name
}

resource "azurerm_resource_group" "rg-mgmt" {
  name     = "rg-mgmt-weu-${var.resourcesuffix}"
  location = var.location
}

resource "azurerm_subnet" "snet-mgmt" {
  name                 = "snet-mgmt"
  resource_group_name  = data.azurerm_resource_group.rg-network.name
  virtual_network_name = data.azurerm_virtual_network.vnet1.name
  address_prefixes     = var.snet-mgmt_prefix
}

locals {
  dummy_route_table_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Network/routeTables/rt"
  perform_route_table_association = var.route_table_id != "" ? "true" : "false"
  route_table_id = var.route_table_id != "" ? var.route_table_id : local.dummy_route_table_id
}

resource "azurerm_subnet_route_table_association" "snet-mgmt-udr" {
  count = local.perform_route_table_association == "true" ? 1 : 0
  subnet_id      = azurerm_subnet.snet-mgmt.id
  route_table_id = local.route_table_id
}





###
# Create a password
resource "random_password" "mt01-local-password" {
  length = 16
  special = true
  min_special = 2
  override_special = "*!@#?"
}


resource "azurerm_public_ip" "mt01-nic-001-pip" {
  count               = var.ignore_pip == true ? 0 : 1
  name                = "${local.vmResourceName}-nic-001-pip"
  resource_group_name = azurerm_resource_group.rg-mgmt.name
  location            = var.location
  allocation_method   = "Static"
  tags = var.common_tags

  lifecycle {
      # Without this lifecycle the pip can't be removed because it's assigned to the nic
      create_before_destroy = true
  }
}

resource "azurerm_network_interface" "mt01-nic-001" {
  name                = "${local.vmResourceName}-nic-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-mgmt.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-mgmt.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.MGMT_IP
    public_ip_address_id          = var.ignore_pip == true ?  null : azurerm_public_ip.mt01-nic-001-pip[0].id
  }
  tags = var.common_tags
}

resource "azurerm_windows_virtual_machine" "mt01" {
  name                = "${local.vmResourceName}"
  computer_name       = "${var.computerName}"
  resource_group_name = azurerm_resource_group.rg-mgmt.name
  location            = azurerm_resource_group.rg-mgmt.location
  size                = "Standard_B2ms"
  admin_username      = "cladmin"
  admin_password      = random_password.mt01-local-password.result

  network_interface_ids = [
    azurerm_network_interface.mt01-nic-001.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  identity {
    type         = "SystemAssigned"
  }
/*
  boot_diagnostics {
    storage_account_uri = "https://${var.diagnostics_storage_account_name}.blob.core.windows.net"
  }
*/
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = var.image_sku
    version   = "latest"
  }
  
  tags = merge(var.common_tags,
  {
    Status       = var.MGMT_status
    SLA          = var.MGMT_SLA
    Billable     = "Billable-Dynamic"
    Owner        = "Cloud"
    BackupPolicy = var.MGMT_backuppolicy
    Product      = var.MGMT_product
    OSType       = "Windows"
    UpdateGroup  = "1"
  })
}

# Create Subnet NSG
resource "azurerm_network_security_group" "snet-mgmt-nsg" {
  name                = "snet-mgmt-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-mgmt.name

  security_rule {
    name                       = "RDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    #source_address_prefix      = "*"
    source_address_prefixes    = concat(["212.61.188.210/32","212.61.222.162/32","212.61.20.1/32","83.167.219.30/32"], var.rdp_whitelist_ips)
    destination_address_prefix = "${azurerm_network_interface.mt01-nic-001.private_ip_address}/32"
  }
  
  # Allow VnetInbound traffic only from own vnet and not from VPN remote ranges
  security_rule {
    name                       = "AllowVnetOnlyInBound"
    priority                   = 4095
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = data.azurerm_virtual_network.vnet1.address_space
    destination_address_prefix = "*"
  }
   # Deny default VnetInbound traffic because it also contains all VPN traffic which we dont want te be whitelisted
   security_rule {
    name                       = "DenyDefaultVnetInBound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  tags = var.common_tags
}

resource "azurerm_subnet_network_security_group_association" "snet-mgmt-nsg-Assoc" {
  subnet_id                 = azurerm_subnet.snet-mgmt.id
  network_security_group_id = azurerm_network_security_group.snet-mgmt-nsg.id
}

