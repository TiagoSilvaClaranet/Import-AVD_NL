############################
# Create a password
############################
resource "random_password" "sharedfileserver-local-password" {
  length = 16
  special = true
  min_special = 2
  override_special = "*!@#?"
}

############################
# Create a NIC
############################
resource "azurerm_network_interface" "sharedfileserver-nic-001" {
  name                = "${var.nlcnumber}-${var.servername}-nic-001"
  location            = data.azurerm_resource_group.rg-sharedresources.location
  resource_group_name = data.azurerm_resource_group.rg-sharedresources.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.snet-shared.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.fileserver_ip
  }

  #lifecycle {
    # Ignore changes to internal_domain_name_suffix, e.g. because a management agent
    # updates these based on some ruleset managed elsewhere.
  #  ignore_changes = [internal_domain_name_suffix]
  #}

  tags = merge(var.common_tags,
  {
    #Status       = var.sharedfileserver_status
    Billable     = var.sharedfileserver_Billable
    Customer     = var.nlcnumber
    Owner        = var.sharedfileserver_owner
  })
  
}
####################################
# Create Fileserver Virtual Machine
####################################
resource "azurerm_windows_virtual_machine" "sharedfileserver" {
  name                = "${var.nlcnumber}-${var.servername}"
  computer_name       = var.servername
  resource_group_name = data.azurerm_resource_group.rg-sharedresources.name
  location            = data.azurerm_resource_group.rg-sharedresources.location
  size                = var.fileserver_skusize
  admin_username      = var.admin_username
  admin_password      = random_password.sharedfileserver-local-password.result
  network_interface_ids = [
    azurerm_network_interface.sharedfileserver-nic-001.id
  ]

  os_disk {
    caching              = var.os_caching
    storage_account_type = var.os_storage_type
  }

/*
  boot_diagnostics {
    storage_account_uri = "https://${var.diagnostics_storage_account_name}.blob.core.windows.net"
  }
*/
  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  identity {
    type         = "SystemAssigned"
  }

  tags = merge(var.common_tags,
  {
    #Environment  = var.environment
    Status       = var.sharedfileserver_status
    SLA          = var.sharedfileserver_SLA
    Billable     = var.sharedfileserver_Billable
    Customer     = var.nlcnumber
    Owner        = var.sharedfileserver_owner
    BackupPolicy = var.sharedfileserver_backuppolicy 
    Product      = var.sharedfileserver_product
    OSType       = "Windows"
    UpdateGroup  = "1"
  })

}

############################
# Create Data Disks
############################
resource "azurerm_managed_disk" "sharedfileserver_DataDisk_1" {
  name                 = "${var.nlcnumber}-${var.servername}_DataDisk_1"
  location             = data.azurerm_resource_group.rg-sharedresources.location
  resource_group_name  = data.azurerm_resource_group.rg-sharedresources.name
  storage_account_type = var.DATA_storage_type
  create_option        = "Empty"
  disk_size_gb         = var.data_disk1_size
  
  tags = merge(var.common_tags,
  {
    #Environment  = var.environment
    Status       = var.sharedfileserver_status
    SLA          = var.sharedfileserver_SLA
    Billable     = var.sharedfileserver_Billable
    Customer     = var.nlcnumber
    Owner        = var.sharedfileserver_owner
    BackupPolicy = var.sharedfileserver_backuppolicy 
    Product      = var.sharedfileserver_product
  })


}

############################
# Attach Data Disks
############################
resource "azurerm_virtual_machine_data_disk_attachment" "sharedfileserver_DataDisk_1" {
  managed_disk_id    = azurerm_managed_disk.sharedfileserver_DataDisk_1.id
  virtual_machine_id = azurerm_windows_virtual_machine.sharedfileserver.id
  lun                = "1"
 # caching            = "ReadWrite"
  caching            = "None"
}


############################
# Join VM to domain
############################
# TODO: Make this dynamic based on if there is a domain or not
module "adjoin-sharedfileserver" {
  count                         = var.join_adds_password != "" ? 1 : 0
  source                        = "git::https://dev.azure.com/claranetbenelux/Worksmart365/_git/tf-azure-ad-join?ref=v1.0.0"
  resource_group_name           = azurerm_windows_virtual_machine.sharedfileserver.resource_group_name
  vmname                        = azurerm_windows_virtual_machine.sharedfileserver.name
  active_directory_domain       = var.join_adds_domain_name
  active_directory_username     = var.join_adds_username
  active_directory_password     = var.join_adds_password
  #depends_on                    = [azurerm_windows_virtual_machine.sharedfileserver]
}


##########################################
# Add Network Security Rules
##########################################
resource "azurerm_network_security_rule" "FS-Allow_ICMP_IN" {
   resource_group_name         = data.azurerm_resource_group.rg-sharedresources.name
   network_security_group_name = data.azurerm_network_security_group.snet-shared-nsg.name
   name                        = "Allow_ICMP_IN_${azurerm_windows_virtual_machine.sharedfileserver.name}"
   priority                    = 200
   description                 = "Allow ICMP traffic to ${azurerm_windows_virtual_machine.sharedfileserver.name}"
   direction                   = "Inbound"
   access                      = "Allow"
   protocol                    = "Icmp"
   source_port_range           = "*"
   destination_port_range      = "*"
   source_address_prefix       = "*"
   destination_address_prefix  = "${azurerm_network_interface.sharedfileserver-nic-001.private_ip_address}/32"
}

resource "azurerm_network_security_rule" "FS-SMB" {
   resource_group_name         = data.azurerm_resource_group.rg-sharedresources.name
   network_security_group_name = data.azurerm_network_security_group.snet-shared-nsg.name
   name                       = "SMB"
   priority                   = 300
   description                = "Allow SMB traffic to ${azurerm_windows_virtual_machine.sharedfileserver.name}"
   direction                  = "Inbound"
   access                     = "Allow"
   protocol                   = "Tcp"
   source_port_range          = "*"
   destination_port_range     = "445"
   source_address_prefix      = "*"
   destination_address_prefix = "${azurerm_network_interface.sharedfileserver-nic-001.private_ip_address}/32"
}

