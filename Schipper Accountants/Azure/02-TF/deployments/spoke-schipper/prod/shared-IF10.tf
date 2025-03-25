/* 

This is a template to create a VM 
Use search and replace to configure it to own settings

Attention!! Search and replace the whole value, so IF10 and not VM!

Base value:
Template value:     IF10
Example:            IF10

IP Adress
Template value:     10.252.27.5
Example:            10.252.27.5

Resource group
Template value:     rg-spoke-schipper-shared
Example:            rg-spoke-schipper-shared

Subnet
Template value:     snet-schipper
Example:            snet-schipper

*/

############################
# Create a password for IF10
############################
resource "random_password" "IF10-local-password" {
  length           = 16
  special          = true
  min_special      = 2
  override_special = "*!@#?"
}

############################
# Create a NIC for IF10
############################
resource "azurerm_network_interface" "IF10_nic_001" {
  name                = "${var.nlcnumber}-IF10-nic-001"
  resource_group_name = azurerm_resource_group.rg-spoke-schipper-shared.name
  location            = azurerm_resource_group.rg-spoke-schipper-shared.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-schipper.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.252.27.5"
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
# Create IF10 Virtual Machine
####################################
resource "azurerm_windows_virtual_machine" "IF10_VM" {
  name                = "${var.nlcnumber}-IF10"
  computer_name       = "IF10"
  resource_group_name = azurerm_resource_group.rg-spoke-schipper-shared.name
  location            = azurerm_resource_group.rg-spoke-schipper-shared.location
  size                = "Standard_B2ms"
  admin_username      = "cladmin"
  admin_password      = random_password.IF10-local-password.result
  network_interface_ids = [
    azurerm_network_interface.IF10_nic_001.id
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

############################
# Create Data Disk 1
############################

# Disk creation 
resource "azurerm_managed_disk" "IF10_DataDisk_1" {
  name                 = "${var.nlcnumber}-IF10-DataDisk_1"
  resource_group_name  = azurerm_resource_group.rg-spoke-schipper-shared.name
  location             = azurerm_resource_group.rg-spoke-schipper-shared.location
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "512"

  tags = merge(local.common_tags,
    {
      Status       = "Production"
      Billable     = "Billable-Dynamic"
      Owner        = "Cloud"
      BackupPolicy = "BackupDaily-90Days"
  })

}

# Disk assignment
resource "azurerm_virtual_machine_data_disk_attachment" "IF10_DataDisk_1" {
  managed_disk_id    = azurerm_managed_disk.IF10_DataDisk_1.id
  virtual_machine_id = azurerm_windows_virtual_machine.IF10_VM.id
  lun                = "1"
  caching            = "None"
}

################################################################
## Run post_script.ps1 on Virtual Machine
################################################################
resource "azurerm_virtual_machine_extension" "post_script_IF10" {
  name                       = "post_script_IF10"
  virtual_machine_id         = azurerm_windows_virtual_machine.IF10_VM.id
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

output "IF10-password" {
  value     = random_password.IF10-local-password.result
  sensitive = true
}