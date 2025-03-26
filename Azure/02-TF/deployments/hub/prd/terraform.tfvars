# Core variables
environment    = "Production"
nlcnumber      = "NLC000883"
resourcesuffix = "001"

############################################################
# Worksmart365 Hub Configuration (Core configuration)
############################################################

# Network (included)
vnet1_address_space         = ["10.252.17.0/24"]
#vnet1_dns_servers          = ["168.63.129.16"] # = Azure DNS server
vnet1_dns_servers           = ["10.252.17.20", "10.252.17.21"] # Use this line when using own DNS servers (from Identity module)
vnet1_gateway_subnet_prefix = ["10.252.17.0/28"]

# Management Services (v1.0.0)
snet-mgmt_prefix        = ["10.252.17.32/28"]
MGMT_IP                 = "10.252.17.36"
mgmt_vmName             = "MT10" # Default is MT01 for the Azure VM resource name, could be conflicting with existing mgmt server
mgmt_computerName       = "MT10" # Default is MT01 for NETBIOS computer name, could be conflicting with already existing mgmt server
MGMT_backuppolicy       = "BackupDaily-90Days"
MGMT_rdp_whitelist_ips  = ["10.252.17.116/32"]

# Bastion Host (v1.0.0)
deploy_bastion        = false
bastion_subnet_prefix = "10.252.xx.192/26"
bastion_sku           = "Basic" # Possible options are Basic / Standard. Default is Basic

# Optional Bastion Options
bastion_copy_paste_enabled = true  # possible true / false. Default is true
bastion_file_copy_enabled  = false # possible true / false Default is false. This is only usable with SKU Standard


# Sharedservices
# Governance
enable_update_management        = true
enable_change_tracking          = true
enable_alerting                 = true # Set to true if customer has support contract
alerting_deploy_dev_action_rule = true # Set this to true if you want to suppress action rules for an evironment
keyvault_user_object_ids        = ["0e1d51ab-9386-4649-871f-23d58d950fdb","3e72e4aa-d82f-406f-8c89-b460223de6da","5543dc99-6dda-4272-b4ba-63886ca855bc","83aa8c2b-457b-4a58-af5b-3be06934ea4f"] # Object id('s) from users here
keyvault_service_principal_ids  = ["2ddacb9c-9bee-4350-a729-e03d09dd4d91"] # Object id('s) from service principals (Enterprise applications) here

# Shared Resources (included)
snet-shared_prefix = ["10.252.17.64/27"]
#trusted_spoke_vnet = ["10.252.xx.0/26", "10.252.xx.128/26"] # Add all spoke address ranges in CIDR notation seperated with a ,

# Printix
deploy_printix = false


# Identity
# Also change vnet1_dns_servers in the Network block to de DC's if you enable the identity module
deploy_identity               = true # Set to true to deploy an IdP
deploy_adds                   = true # Set to true if native ADDS is needed
first_dc_computer_name        = "DC10"
first_dc_vm_name              = "DC10"
second_dc_computer_name       = "DC11"
second_dc_vm_name             = "DC11"
adds_deployment_scenario      = "Brownfield" # This can be set to Greenfield for a clean environment or Brownfield for an existing environment
snet-identity_prefix          = ["10.252.17.16/28"]
adds_dc_ips                   = ["10.252.17.20", "10.252.17.21"] # For now we have to manually enter this information
adds_domain_name              = "schgoe.local"                   # Specify the name of the domain to be created
active_directory_netbios_name = "schgoe.local"                   # Optional. Default is 'adds' 
adds_ad_userpassword          = "Default"
adds_cbx_backup_policy        = "BackupDaily-90Days"
adds_image_sku                = "2022-Datacenter"



# Shared Fileserver
deploy_sharedfileserver    = false
fileserver_resource_group  = "rg-sharedresources-weu-001" # Default is "rg-sharedresources-weu-001"
fileserver_servername      = "FS01"                       # Default is 'FS01'
fileserver_ip              = "10.252.17.68"
fileserver_data_disk1_size = "32"

# Optional
fileserver_skusize   = "Standard_B2ms"   # Default is 'Standard_B2ms'
fileserver_image_sku = "2022-Datacenter" # Default is '2019-Datacenter'

# Fortigate NVA (single - Non HA)
deploy_fortigate         = true
fortigate_license_type   = "byol"                 # Can be boyl or payg, when boyl is selected valid .lic must fill in
fortigate_license_file   = "FGVM1VTM22009254.lic" # Put .lic file in same directory as tvars
fortigate_address_prefix = "10.252.17.0/24"
fortigate_publiccidr     = "10.252.17.96/28"
fortigate_privatecidr    = "10.252.17.112/28"
fortigate_external_ip    = "10.252.17.100"
fortigate_internal_ip    = "10.252.17.116"
fortigate_version        = "7.0.6"
fortigate_size           = "Standard_DS1_v2"