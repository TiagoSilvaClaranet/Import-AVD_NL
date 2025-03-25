# Caseware Fileserver
# Name CWCWFS10
# SKU D2s_v5 (2 CPU's, 8GB memory)
# C: 4TB Premium SSD (P50) - OS
# Backup 90d LRS
# t.z.t. 1 jaar reservering toevoegen
# Resource Group rg-spoke-schipper-caseware


/* 

This is a template to create a VM 
Use search and replace to configure it to own settings

Attention!! Search and replace the whole value, so CWFS10 and not VM!

Base value:
Template value:     CWFS10
Example:            IF10

IP Adress
Template value:     10.252.27.8
Example:            10.252.17.5

Resource group
Template value:     rg-spoke-schipper-caseware
Example:            rg-spoke-schipper-caseware

Subnet
Template value:     snet-schipper
Example:            snet-schipper

*/

###############################
# Create a password for CWFS10
###############################
resource "random_password" "CWFS10-local-password" {
  length           = 16
  special          = true
  min_special      = 2
  override_special = "*!@#?"
}

############################
# Create a NIC for CWFS10
############################
resource "azurerm_network_interface" "CWFS10_nic_001" {
  name                = "${var.nlcnumber}-CWFS10-nic-001"
  resource_group_name = azurerm_resource_group.rg-spoke-schipper-caseware.name
  location            = azurerm_resource_group.rg-spoke-schipper-caseware.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-schipper.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.252.27.8"
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
# Create CWFS10 Virtual Machine
####################################
resource "azurerm_windows_virtual_machine" "CWFS10_VM" {
  name                = "${var.nlcnumber}-CWFS10"
  computer_name       = "CWFS10"
  resource_group_name = azurerm_resource_group.rg-spoke-schipper-caseware.name
  location            = azurerm_resource_group.rg-spoke-schipper-caseware.location
  size                = "Standard_D2ds_v5"
  admin_username      = "cladmin"
  admin_password      = random_password.CWFS10-local-password.result
  network_interface_ids = [
    azurerm_network_interface.CWFS10_nic_001.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
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
# Create Data Disk 1 (Caseware Data)
#################################

# Disk creation 
resource "azurerm_managed_disk" "CWFS10_DataDisk_2" {
  name                 = "${var.nlcnumber}-CWFS10-DataDisk-casewaredata-2"
  resource_group_name  = azurerm_resource_group.rg-spoke-schipper-caseware.name
  location             = azurerm_resource_group.rg-spoke-schipper-caseware.location
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "8192"

  tags = merge(local.common_tags,
    {
      Status       = "Production"
      Billable     = "Billable-Dynamic"
      Owner        = "Cloud"
      BackupPolicy = "BackupDaily-90Days"
  })

}

# Disk assignment
resource "azurerm_virtual_machine_data_disk_attachment" "CWFS10_DataDisk_2" {
  managed_disk_id    = azurerm_managed_disk.CWFS10_DataDisk_2.id
  virtual_machine_id = azurerm_windows_virtual_machine.CWFS10_VM.id
  lun                = "1"
  caching            = "None"
}

################################################################
## Run post_script.ps1 on Virtual Machine
################################################################
resource "azurerm_virtual_machine_extension" "post_script_CWFS10" {
  name                       = "post_script_CWFS10"
  virtual_machine_id         = azurerm_windows_virtual_machine.CWFS10_VM.id
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

output "CWFS10-password" {
  value     = random_password.CWFS10-local-password.result
  sensitive = true
}