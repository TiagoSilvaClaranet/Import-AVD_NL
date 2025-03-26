/* 

This is a template to create a SQLVM 
Use search and replace to configure it to own settings

Attention!! Search and replace the whole value, so SQ10 and not VM!

Base value:
Template value:     SQ10
Example:            IF10

IP Adress
Template value:     10.252.27.7
Example:            10.252.17.5

Resource group
Template value:     rg-spoke-schipper-shared
Example:            rg-spoke-schipper-shared

Subnet
Template value:     snet-schipper
Example:            snet-schipper

*/

############################
# Create a NIC for SQ10
############################

resource "azurerm_network_interface" "SQ10_nic_001" {
  name                = "${var.nlcnumber}-SQ10-nic-001"
  resource_group_name = azurerm_resource_group.rg-spoke-schipper-shared.name
  location            = azurerm_resource_group.rg-spoke-schipper-shared.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-schipper.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.252.27.7"
  }

  tags = merge(local.common_tags,
    {
      Status       = "Production"
      Billable     = "Billable-Dynamic"
      Owner        = "Cloud"
      BackupPolicy = "BackupDaily-90Days"
  })

}

##########################################
# Azure Virtual Machine
##########################################

# Generate password
resource "random_password" "SQ10-local-password" {
  length           = 16
  special          = true
  min_special      = 2
  override_special = "*!@#?"
}

# Create Virtual Machine
resource "azurerm_virtual_machine" "SQ10-vm" {
  name                  = "${var.nlcnumber}-SQ10"
  resource_group_name   = azurerm_resource_group.rg-spoke-schipper-shared.name
  location              = azurerm_resource_group.rg-spoke-schipper-shared.location
  network_interface_ids = [azurerm_network_interface.SQ10_nic_001.id]
  vm_size               = "Standard_E2ds_v5"

  storage_image_reference {
    publisher = "MicrosoftSQLServer"
    offer     = "sql2019-ws2022"
    sku       = "standard-gen2"
    version   = "latest"
  }

  storage_os_disk {
    name              = "SQ10-OS-Disk-01"
    caching           = "ReadOnly"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = "SQ10"
    admin_username = "cladmin"
    admin_password = random_password.SQ10-local-password.result
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
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

##########################################
# Create and attach storage disks
##########################################

# Data disk creation
resource "azurerm_managed_disk" "SQ10_DataDisk_1" {
  name                 = "${var.nlcnumber}-SQ10-DataDisk-1"
  resource_group_name  = azurerm_resource_group.rg-spoke-schipper-shared.name
  location             = azurerm_resource_group.rg-spoke-schipper-shared.location
  storage_account_type = "Premium_LRS"
  zone                 = "1"
  create_option        = "Empty"
  disk_size_gb         = "128"
  tags = merge(local.common_tags,
    {
      Status       = "Production"
      Billable     = "Billable-Dynamic"
      Owner        = "Cloud"
      BackupPolicy = "BackupDaily-90Days"
  })
}

# Data disk attachment
resource "azurerm_virtual_machine_data_disk_attachment" "SQ10_DataDisk_1_attach" {
  managed_disk_id    = azurerm_managed_disk.SQ10_DataDisk_1.id
  virtual_machine_id = azurerm_virtual_machine.SQ10-vm.id
  lun                = 1
  caching            = "ReadWrite"
}



##########################################
# Create Azure SQL Virtual Machine
##########################################

# Create SQL Virtual Machines based on initial Azure Virtual Machine and set SQL license
resource "azurerm_mssql_virtual_machine" "SQ10_mssql" {
  virtual_machine_id    = azurerm_virtual_machine.SQ10-vm.id
  sql_license_type      = "PAYG"
  r_services_enabled    = true
  sql_connectivity_port = 1433
  sql_connectivity_type = "PRIVATE"

  storage_configuration {
    disk_type             = "NEW"  # (Required) The type of disk configuration to apply to the SQL Server. Valid values include NEW, EXTEND, or ADD.
    storage_workload_type = "OLTP" # (Required) The type of storage workload. Valid values include GENERAL, OLTP, or DW.

    # The storage_settings block supports the following:
    data_settings {
      default_file_path = "F:\\Data" # (Required) The SQL Server default path
      luns              = [azurerm_virtual_machine_data_disk_attachment.SQ10_DataDisk_1_attach.lun]
    }

    log_settings {
      default_file_path = "F:\\log"                                                                # (Required) The SQL Server default path
      luns              = [azurerm_virtual_machine_data_disk_attachment.SQ10_DataDisk_1_attach.lun] # (Required) A list of Logical Unit Numbers for the disks.
    }

    temp_db_settings {
      default_file_path = "F:\\tempdb"                                                                # (Required) The SQL Server default path
      luns              = [azurerm_virtual_machine_data_disk_attachment.SQ10_DataDisk_1_attach.lun] # (Required) A list of Logical Unit Numbers for the disks.
    }

  }

}


################################################################
## Run post_script.ps1 on Virtual Machine
################################################################
resource "azurerm_virtual_machine_extension" "post_script_SQ10" {
  name                       = "post_script_SQ10"
  virtual_machine_id         = azurerm_virtual_machine.SQ10-vm.id
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

# Outputs
output "SQ10-password" {
  value     = random_password.SQ10-local-password.result
  sensitive = true
}




