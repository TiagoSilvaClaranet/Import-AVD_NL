#########################################################
# Retrieve Resource Group properties
#########################################################
data "azurerm_resource_group" "avd-rg" {
  name = var.resource_group_name
}

# Create a timestamp to use for VM naming convention
resource "time_static" "vmtimestamp" {}

#########################################################
# Add Session Hosts
#########################################################
module "avd-sessionhosts" {
  source                 = "./modules/tf-azurerm-avd-hostpool-addhosts"
  resource_group         = data.azurerm_resource_group.avd-rg.name
  location               = data.azurerm_resource_group.avd-rg.location

  #avd_host_pool_id       = module.avd-hostpool-dev.host_pool_id
  avd_host_pool_id       = var.avd_host_pool_id
  avd_host_pool_size     = var.avd_host_pool_size
  avd_starting_offset    = var.avd_starting_offset
  subnet_id              = local.subnet_id
  vm_size                = var.vm_size
  storage_account_type   = var.storage_account_type
  #avd_registration_token = var.avd_hostpool_registration_token
  avd_host_pool_name     = var.avd_host_pool_name

  nlcnumber              = var.nlcnumber
  prefix                 = var.prefix
  # Resource names of Session Hosts VM's will start with [nlcnumber]-[prefix] (For example NLC123456-customer-vdsh-1)

  vmprefix               = local.vmprefix # If ommited it will use 'vdsh'

  # Deploy using an 'source_image_id' or by 'source_image_reference'
  # If 'source_image_id' is set it overrules the 'source_image_reference
  source_image_id        = var.source_image_id
  # Alternativly retrieve data object 
  # TODO
  #source_image_id        = data.azurerm_shared_image.avdimage.id

  used_image              = local.sig_image_tag

  # image_publisher = "MicrosoftWindowsDesktop"
  # image_offer     = "Windows-11"
  # image_sku       = "win11-22h2-avd"
  # image_version   = "latest"

  domain_name           = var.domain_name
  domain_user_upn       = var.domain_user_upn # Should be vmjoiner account
  #domain_user_password = var.domain_user_password # Should retrieve password from Azure KeyVault
  domain_user_password  = data.azurerm_key_vault_secret.vmjoiner.value # Should retrieve password from Azure KeyVault
  avd_ou_path           = var.avd_ou_path                              # "OU=AVD,OU=AAD,DC=contoso,DC=net"

  log_analytics_workspace_id  = var.log_analytics_workspace_id
  log_analytics_workspace_key = data.azurerm_key_vault_secret.avdlaw-secret.value

  dcr_id                = var.dcr_id
  dcr-vmi_id            = var.dcr-vmi_id

}
