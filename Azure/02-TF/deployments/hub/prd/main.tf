# Create resources using modules

############################################################
# Module Network
# Included
# v1.0.0
############################################################

module "network" {
  # Module configuration
  source = "../../../modules/network"
  # Global settings
  location              = var.location
  nlcnumber             = var.nlcnumber
  resourcesuffix        = var.resourcesuffix
  # Network settings
  address_space         = var.vnet1_address_space
  dns_servers           = var.vnet1_dns_servers
  gateway_subnet_prefix = var.vnet1_gateway_subnet_prefix
  common_tags           = local.common_tags
}

############################################################
# Module Shared Services
# Included
# v1.0.0
############################################################

module "sharedservices" {
  # Module configuration
  source = "../../../modules/sharedservices"
  # Global settings
  location       = var.location
  nlcnumber      = var.nlcnumber
  resourcesuffix = var.resourcesuffix
  # General settings
  enable_update_management        = var.enable_update_management
  enable_change_tracking          = var.enable_change_tracking
  enable_alerting                 = var.enable_alerting
  deploy_dev_action_rule          = var.alerting_deploy_dev_action_rule
  keyvault_user_object_ids        = var.keyvault_user_object_ids
  keyvault_service_principal_ids  = var.keyvault_service_principal_ids

  # Dependency 
  depends_on = [module.network]
}

############################################################
# Module  Management Services
# v1.0.0
############################################################

module "mgmt" {
  # Module configuration
  source = "../../../modules/mgmt"
  # Global settings
  location          = var.location
  nlcnumber         = var.nlcnumber
  resourcesuffix    = var.resourcesuffix
  # Network settings
  snet-mgmt_prefix = var.snet-mgmt_prefix
  route_table_id   = try(module.fortigate[0].route_table_id,"")
  MGMT_IP          = var.MGMT_IP
  computerName      = var.mgmt_computerName
  vmName            = var.mgmt_vmName
  rdp_whitelist_ips = var.MGMT_rdp_whitelist_ips
  # General settings
  ignore_pip       = var.deploy_fortigate # pip wil only be created when deploy_fortigate is set to false
  image_sku         = var.mgmt_imagesku
  common_tags       = local.common_tags  
  MGMT_backuppolicy = var.MGMT_backuppolicy

  # Dependency 
  depends_on = [module.network]
}


############################################################
# Module Shared Resources
# Included
# v1.0.0
############################################################

module "sharedresources" {
  # Module configuration
  source = "../../../modules/sharedresources"
  # Global settings
  location       = var.location
  nlcnumber      = var.nlcnumber
  environment    = var.environment
  resourcesuffix = var.resourcesuffix
  # Network settings
  snet_prefix        = var.snet-shared_prefix
  trusted_spoke_vnet = var.trusted_spoke_vnet
  route_table_id     = try(module.fortigate[0].route_table_id,"")
  # Dependency
  depends_on = [module.network]
}

############################################################
# Module Printix
# tf-azure-printix
# v1.0.0
############################################################

module "printix" {
  # Module switch (on/off)
  count = var.deploy_printix == true ? 1 : 0
  # Module configuration
  source = "git::https://dev.azure.com/claranetbenelux/Worksmart365/_git/tf-printix?ref=v1.0.0"
  # Global settings
  location  = var.location
  nlcnumber = var.nlcnumber
}

############################################################
# Module Identity
# tf-azure-adds
# v1.0.0
############################################################

module "identity" {
  # Module switch (on/off)
  count = var.deploy_adds == true ? 1 : 0

  # Module configuration
  source = "git::https://dev.azure.com/claranetbenelux/Worksmart365/_git/tf-azure-adds-dualdc?ref=v2.0.5"

  # Global settings
  location        = var.location
  nlcnumber       = var.nlcnumber
  common_tags     = local.common_tags
  resourcesuffix  = var.resourcesuffix

  # Network settings
  snet_prefix      = var.snet-identity_prefix
  adds_dc_ips      = var.adds_dc_ips
  route_table_id   = try(module.fortigate[0].route_table_id,"")

  # Domain settings
  deployment_scenario           = var.adds_deployment_scenario # default is greenfield, when false please fill in the # Optional (brownfield) settings
  first_dc_computer_name        = var.first_dc_computer_name
  first_dc_vm_name              = var.first_dc_vm_name
  second_dc_computer_name       = var.second_dc_computer_name
  second_dc_vm_name             = var.second_dc_vm_name
  adds_domain_name              = var.adds_domain_name #FQDN for example 'adds.domein.nl'
  active_directory_netbios_name = var.active_directory_netbios_name
  image_sku                     = var.adds_image_sku
  cbx_backup_policy             = var.adds_cbx_backup_policy
  local_admin_acount            = var.adds_local_admin_acount

  # If brownfield
  ad_username                   = var.adds_ad_username 
  ad_userpassword               = var.adds_ad_userpassword

  # Dependency 
  depends_on = [module.network]
}


#######################################################

############################################################
# Module Shared Fileserver
# included
# v1.0.0
############################################################

module "sharedfileserver" {
  # Module switch (on/off)
  count = var.deploy_sharedfileserver == true ? 1 : 0
  # Module configuration
  source = "../../../modules/sharedfileserver"
  # Global settings
  resource_group          = "${var.fileserver_resource_group}-${var.resourcesuffix}"
  location                = var.location
  nlcnumber               = var.nlcnumber
  common_tags             = local.common_tags
  sharedfileserver_status = "Development"
  # Network settings
  fileserver_ip = var.fileserver_ip
  # General settings
  servername         = var.fileserver_servername # Default is 'FS01'
  data_disk1_size    = var.fileserver_data_disk1_size
  fileserver_skusize = var.fileserver_skusize   # Default is 'Standard_B2ms'
  image_sku          = var.fileserver_image_sku # Default is '2019-Datacenter'
  # Domain settings
  join_adds_username = "cladmin"
  join_adds_password = module.identity[0].dc01-password
  # Dependency    
  depends_on = [module.network]
}

############################################################
# Module Fortigate
# tf-azure-fortigate
# v1.0.8
############################################################

module "fortigate" {
  # Module switch (on/off)
  count = var.deploy_fortigate == true ? 1 : 0
  # Module configuration
  source = "git::https://dev.azure.com/claranetbenelux/Worksmart365/_git/tf-azure-fortigate?ref=v1.0.8"
  # Global settings
  resource_group = "rg-fortigate-weu-${var.resourcesuffix}" # Resource Group to create resources in
  location       = var.location           # Region to create resources in
  nlcnumber      = var.nlcnumber          # =Prefix
  common_tags    = local.common_tags      # Common tags to apply
  # General settings
  fgtversion   = var.fortigate_version # Used 7.0.6 release, Infrateam standard greenfield deployment version
  license      = var.fortigate_license_file
  license_type = var.fortigate_license_type
  # Network settings
  vnet           = "vnet-prod-weu-${var.resourcesuffix}"  # VNET to create subnets in
  vnet_rg        = "rg-network-weu-${var.resourcesuffix}" # Resource group the VNET lives in
  address_prefix = var.fortigate_address_prefix # Route
  publiccidr     = var.fortigate_publiccidr     # External Subnet
  privatecidr    = var.fortigate_privatecidr    # Internal Subnet
  external_IP    = var.fortigate_external_ip    # External IP
  internal_IP    = var.fortigate_internal_ip    # Internal IP  
  size           = var.fortigate_size           # Size of the Fortigate  
}

############################################################
# Module Bastion
# tf-azure-bastion
# v1.0.0
############################################################

module "tf-azure-bastion-hub" {
  count               = var.deploy_bastion == true ? 1 : 0
  source              = "git::https://dev.azure.com/claranetbenelux/Worksmart365/_git/tf-azure-bastion?ref=v1.0.0"
  location            = var.location
  resource_group_name = "rg-bastion-weu-${var.resourcesuffix}"
  subnet_prefix       = var.bastion_subnet_prefix
  allocation_method   = "Static"
  sku                 = var.bastion_sku
  copy_paste_enabled  = var.bastion_copy_paste_enabled
  file_copy_enabled   = var.bastion_file_copy_enabled
  common_tags         = local.common_tags
}
