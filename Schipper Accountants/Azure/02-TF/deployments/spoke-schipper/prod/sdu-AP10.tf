# SDU Applicatieserver
# Name APxx
# SKU B2ms (2 CPU's, 8GB memory)
# C: 128GB Standard SSD (E10) - OS 
# Backup 90d LRS
# t.z.t. 1 jaar reservering toevoegen
# Resource Group rg-schipper-sdu

/* 

This is a template to create a VM 
Use search and replace to configure it to own settings

Attention!! Search and replace the whole value, so AP10 and not VM!

Base value:
Template value:     AP10
Example:            IF10

IP Adress
Template value:     10.252.27.9
Example:            10.252.17.5

Resource group
Template value:     rg-spoke-schipper-sdu
Example:            rg-spoke-schipper-shared

Subnet
Template value:     snet-schipper
Example:            snet-schipper

*/

############################
# Create a password for AP10
############################
resource "random_password" "AP10-local-password" {
  length           = 16
  special          = true
  min_special      = 2
  override_special = "*!@#?"
}

############################
# Create a NIC for AP10
############################
resource "azurerm_network_interface" "AP10_nic_001" {
  name                = "${var.nlcnumber}-AP10-nic-001"
  resource_group_name = azurerm_resource_group.rg-spoke-schipper-sdu.name
  location            = azurerm_resource_group.rg-spoke-schipper-sdu.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-schipper.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.252.27.9"
  }

  tags = merge(local.common_tags,
    {
      Status       = "Production"
      Billable     = "Billable-Dynamic"
      Owner        = "Cloud"
      BackupPolicy = "BackupDaily-90Days"
      UpdateGroup  = "0"
  })

}
####################################
# Create AP10 Virtual Machine
####################################
resource "azurerm_windows_virtual_machine" "AP10_VM" {
  name                = "${var.nlcnumber}-AP10"
  computer_name       = "AP10"
  resource_group_name = azurerm_resource_group.rg-spoke-schipper-sdu.name
  location            = azurerm_resource_group.rg-spoke-schipper-sdu.location
  size                = "Standard_B2ms"
  admin_username      = "cladmin"
  admin_password      = random_password.AP10-local-password.result
  network_interface_ids = [
    azurerm_network_interface.AP10_nic_001.id
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

#   ############################
#   # Create Data Disk 1
#   ############################

#   # Disk creation 
#   resource "azurerm_managed_disk" "AP10_DataDisk_1" {
#   name                 = "${var.nlcnumber}-AP10-DataDisk_1"
#   resource_group_name  = azurerm_resource_group.rg-spoke-schipper-sdu.name
#   location             = azurerm_resource_group.rg-spoke-schipper-sdu.location
#   storage_account_type = "Standard_LRS"
#   create_option        = "Empty"
#   disk_size_gb         = "20"

#   tags = merge(local.common_tags,
#   {
#     Status      = "Production"
#     Billable     = "Billable-Dynamic"
#     Owner        = "Cloud"
#     BackupPolicy = "BackupDaily-90Days"
#   })

#   }

#   # Disk assignment
#   resource "azurerm_virtual_machine_data_disk_attachment" "AP10_DataDisk_1" {
#     managed_disk_id    = azurerm_managed_disk.AP10_DataDisk_1.id
#     virtual_machine_id = azurerm_windows_virtual_machine.AP10_VM.id
#     lun                = "1"
#     caching            = "None"
#   }


################################################################
## Run post_script.ps1 on Virtual Machine
################################################################
resource "azurerm_virtual_machine_extension" "post_script_AP10" {
  name                       = "post_script_AP10"
  virtual_machine_id         = azurerm_windows_virtual_machine.AP10_VM.id
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

output "AP10-password" {
  value     = random_password.AP10-local-password.result
  sensitive = true
}