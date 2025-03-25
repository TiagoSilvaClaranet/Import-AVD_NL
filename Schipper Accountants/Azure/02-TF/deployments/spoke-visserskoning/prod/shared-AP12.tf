/* 

This is a template to create a VM 
Use search and replace to configure it to own settings

Attention!! Search and replace the whole value, so ap12 and not VM!

Base value:
Template value:     ap12
Example:            IF10

IP Adress
Template value:     10.252.27.6
Example:            10.252.17.5

Resource group
Template value:     rg-spoke-visserskoning-shared
Example:            rg-spoke-visserskoning-shared

Subnet
Template value:     snet-visserskoning
Example:            snet-visserskoning

*/

############################
# Create a password for ap12
############################
resource "random_password" "ap12-local-password" {
  length           = 16
  special          = true
  min_special      = 2
  override_special = "*!@#?"
}

############################
# Create a NIC for ap12
############################
resource "azurerm_network_interface" "ap12_nic_001" {
  name                = "${var.nlcnumber}-ap12-nic-001"
  resource_group_name = azurerm_resource_group.rg-spoke-visserskoning-shared.name
  location            = azurerm_resource_group.rg-spoke-visserskoning-shared.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-visserskoning.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.252.28.6"
  }

  tags = merge(local.common_tags,
    {
      Status       = "Production"
      Billable     = "Billable-Dynamic"
      Owner        = "Cloud"
      BackupPolicy = "BackupDaily-90Days"      
  })

}
####################################
# Create ap12 Virtual Machine
####################################
resource "azurerm_windows_virtual_machine" "ap12_VM" {
  name                = "${var.nlcnumber}-ap12"
  computer_name       = "ap12"
  resource_group_name = azurerm_resource_group.rg-spoke-visserskoning-shared.name
  location            = azurerm_resource_group.rg-spoke-visserskoning-shared.location
  size                = "Standard_B2ms"
  admin_username      = "cladmin"
  admin_password      = random_password.ap12-local-password.result
  network_interface_ids = [
    azurerm_network_interface.ap12_nic_001.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = merge(local.common_tags,
    {
      Status       = "Production"
      Billable     = "Billable-Dynamic"
      Owner        = "Cloud"
      BackupPolicy = "BackupDaily-90Days"
      UpdateGroup  = "1"
      OSType       = "Windows"
      SLA          = "10x5"
  })

}

##########################################################
# Additional Storage
##########################################################

#################################
# Create Data Disk 1
#################################

# Disk creation 
resource "azurerm_managed_disk" "ap12_DataDisk_1" {
  name                 = "${var.nlcnumber}-ap12-DataDisk-1"
  resource_group_name  = azurerm_resource_group.rg-spoke-visserskoning-shared.name
  location             = azurerm_resource_group.rg-spoke-visserskoning-shared.location
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "256"

  tags = merge(local.common_tags,
    {
      Status       = "Production"
      Billable     = "Billable-Dynamic"
      Owner        = "Cloud"
      BackupPolicy = "BackupDaily-90Days"
  })

}

# Disk assignment
resource "azurerm_virtual_machine_data_disk_attachment" "ap12_DataDisk_1" {
  managed_disk_id    = azurerm_managed_disk.ap12_DataDisk_1.id
  virtual_machine_id = azurerm_windows_virtual_machine.ap12_VM.id
  lun                = "1"
  caching            = "None"
}


################################################################
## Run post_script.ps1 on Virtual Machine
################################################################
resource "azurerm_virtual_machine_extension" "post_script_ap12" {
  name                       = "post_script_ap12"
  virtual_machine_id         = azurerm_windows_virtual_machine.ap12_VM.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true

  protected_settings = <<SETTINGS
  {
     "commandToExecute": "powershell -encodedCommand ${textencodebase64(file("./scripts/post_script.ps1"), "UTF-16LE")}"
  }
  SETTINGS
}

output "ap12-password" {
  value     = random_password.ap12-local-password.result
  sensitive = true
}