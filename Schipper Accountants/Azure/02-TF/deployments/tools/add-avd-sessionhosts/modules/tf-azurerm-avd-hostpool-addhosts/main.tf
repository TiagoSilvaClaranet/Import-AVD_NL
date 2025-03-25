#########################################
# Create the new session hosts
#########################################

# Create NIC's for the sessions hosts
resource "azurerm_network_interface" "avd" {
  count               = var.avd_host_pool_size
  name                = "${var.nlcnumber}-${var.prefix}-${var.vmprefix}-${count.index + var.avd_starting_offset}-nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "nic${count.index + var.avd_starting_offset}_config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = merge(var.common_tags,
    {
      Customer = var.nlcnumber
      Owner    = var.owner
  })
}

resource "random_password" "avd_local_admin" {
  length           = 16
  special          = true
  min_special      = 2
  override_special = "*!@#?"
}

# Create random ID's (for what?)
resource "random_id" "avd" {
  count       = length(azurerm_network_interface.avd)
  byte_length = 4
}

# Create Virtual Machines
resource "azurerm_windows_virtual_machine" "avd-sessionhosts" {
  count                         = length(random_id.avd)
  #name                         = "avd-vm-${count.index}-${random_id.avd[count.index].hex}"
  name                          = "${var.nlcnumber}-${var.prefix}-${var.vmprefix}-${count.index + var.avd_starting_offset}"
  computer_name                 = "${var.vmprefix}-${count.index + var.avd_starting_offset}"
  location                      = var.location
  resource_group_name           = var.resource_group
  

  #size                  = "Standard_D4s_v5"
  size                  = var.vm_size
  license_type          = "Windows_Client" # Fixed -> Always use this license type otherwise extra license costs are charged and you do not benefit from Azure Hybrid Use benefits
  admin_username        = var.local_admin_username
  admin_password        = random_password.avd_local_admin.result
  network_interface_ids = [azurerm_network_interface.avd[count.index].id]

  os_disk {
    name    = "${var.nlcnumber}-${lower(var.prefix)}-${var.vmprefix}-${count.index + var.avd_starting_offset}"
    caching = "ReadWrite"
    storage_account_type = var.storage_account_type # Default is 'Premium_LRS'
  }

  # Deploy using an source_image_reference or by source_image_id
  # source_image_reference {
  #   publisher = var.image_publisher
  #   offer     = var.image_offer
  #   sku       = var.image_sku
  #   version   = var.image_version
  # }
  
  # source_image_id = data.azurerm_shared_image.example.id # Use this if using Azure Compute Gallery Image
  # Alternative could be to use 'azurerm_shared_image' data object to retrieve the shared image and pass the id property to 'source_image_id'
  source_image_id = var.source_image_id
  
  dynamic "source_image_reference" {
    for_each = var.source_image_id == null ? ["fake"] : []
    content {
      publisher = var.image_publisher
      offer     = var.image_offer
      sku       = var.image_sku
      version   = var.image_version
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = merge(var.common_tags,
    {
      Customer = var.nlcnumber
      Owner    = var.owner
      ImageName = var.used_image
  })
}

########################################
# Install Azure Monitoring Agent (AMA)
########################################
module "vmextention-ama" {
  count              = length(azurerm_windows_virtual_machine.avd-sessionhosts)
  source             = "git::https://dev.azure.com/claranetbenelux/Worksmart365/_git/tf-azure-winvm-ama-extention?ref=v1.0.0"
  virtual_machine_id = azurerm_windows_virtual_machine.avd-sessionhosts[count.index].id
}

########################################
# Install Dependency Agent (AMA)
########################################
module "vmextention-ama-da" {
  count              = length(azurerm_windows_virtual_machine.avd-sessionhosts)
  source             = "git::https://dev.azure.com/claranetbenelux/Worksmart365/_git/tf-azure-winvm-da-extention?ref=v1.0.0"
  virtual_machine_id = azurerm_windows_virtual_machine.avd-sessionhosts[count.index].id
}

########################################
# Join machines to AD
########################################
resource "azurerm_virtual_machine_extension" "avd_aadds_join" {
  count              = length(azurerm_windows_virtual_machine.avd-sessionhosts)
  name               = "${var.nlcnumber}-${var.prefix}-${var.vmprefix}-${count.index + var.avd_starting_offset}-domainJoin"
  virtual_machine_id = azurerm_windows_virtual_machine.avd-sessionhosts[count.index].id
  #virtual_machine_id         = azurerm_windows_virtual_machine.avd-sessionhosts.*.id[count.index]
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true

  settings = <<-SETTINGS
    {
      "Name": "${var.domain_name}",
      "OUPath": "${var.avd_ou_path}",
      "User": "${var.domain_user_upn}@${var.domain_name}",
      "Restart": "true",
      "Options": "3"
    }
    SETTINGS

  protected_settings = <<-PROTECTED_SETTINGS
    {
      "Password": "${var.domain_user_password}"
    }
    PROTECTED_SETTINGS

  lifecycle {
    ignore_changes = [settings, protected_settings]
  }

  depends_on = [azurerm_windows_virtual_machine.avd-sessionhosts]
}

########################################
# Register machines in the Host Pool
########################################
resource "azurerm_virtual_machine_extension" "avd_register_session_host" {
  count                = length(azurerm_windows_virtual_machine.avd-sessionhosts)
  name                 = "${var.nlcnumber}-${var.prefix}-${var.vmprefix}-${count.index + var.avd_starting_offset}-avd_dsc"
  virtual_machine_id   = azurerm_windows_virtual_machine.avd-sessionhosts[count.index].id
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.73"

  settings = <<-SETTINGS
    {
      "modulesUrl": "${var.avd_register_session_host_modules_url}",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "hostPoolName": "${var.avd_host_pool_name}",
        "aadJoin": false
      }
    }
    SETTINGS

  protected_settings = <<-PROTECTED_SETTINGS
    {
      "properties": {
        "registrationInfoToken": "${azurerm_virtual_desktop_host_pool_registration_info.avd_registration_token.token}"
      }
    }
    PROTECTED_SETTINGS

  lifecycle {
    ignore_changes = [settings, protected_settings]
  }

  depends_on = [azurerm_virtual_machine_extension.avd_aadds_join]
}

# "registrationInfoToken": "${var.avd_registration_token}"


########################################
# Assign DCR to Virtual Machines
########################################
resource "azurerm_monitor_data_collection_rule_association" "avd-associate-dcr" {
  count                   = var.enable_dcr == true ? length(azurerm_windows_virtual_machine.avd-sessionhosts) : 0 
  name                    = "avdsh-dcra"
  target_resource_id      = azurerm_windows_virtual_machine.avd-sessionhosts[count.index].id
  data_collection_rule_id = var.dcr_id
  #description             = "example"
  depends_on               = [module.vmextention-ama, azurerm_virtual_machine_extension.avd_register_session_host]
}

resource "azurerm_monitor_data_collection_rule_association" "avd-associate-dcr-vmi" {
  count                   = var.enable_dcr == true ? length(azurerm_windows_virtual_machine.avd-sessionhosts) : 0 
  name                    = "avdsh-dcra-vmi"
  target_resource_id      = azurerm_windows_virtual_machine.avd-sessionhosts[count.index].id
  data_collection_rule_id = var.dcr-vmi_id
  #description             = "example"
  depends_on               = [module.vmextention-ama, azurerm_virtual_machine_extension.avd_register_session_host]
}




  