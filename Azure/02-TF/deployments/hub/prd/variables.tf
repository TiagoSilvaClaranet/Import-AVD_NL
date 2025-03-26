############################################################
# Customer related variables
############################################################

variable "environment" {
  description = "Environment (Development/Production/Test/Acceptance)"
  type        = string
  default     = "Production"
}

variable "location" {
  description = "The region in which to create resources"
  type        = string
  default     = "West Europe"
}

variable "nlcnumber" {
  description = "The messina number of the customer"
  type        = string
}

variable "resourcesuffix" {
  description = "Suffix to append to resource names"
  type        = string
  default     = "001"
}

############################################################
# Variables Module Network
# Included
# v1.0.0
############################################################

variable "vnet1_address_space" {
  description = "Vnet address space"
  type        = list(string)
}

variable "vnet1_dns_servers" {
  description = "DNS servers to be used in VNET"
  type        = list(string)
}
variable "vnet1_gateway_subnet_prefix" {
  description = "Gateway Subnet prefix"
  type        = list(string)
}

############################################################
# Variables Module Management Services
# Worksmart365-Azure-Hub-Modules-Management
# v1.0.0
############################################################

variable "snet-mgmt_prefix" {
  description = "Prefix of snet-mgmt"
  type        = list(string)
}

variable "MGMT_IP" {
  description = "MGMT IP"
  type        = string
}

variable "mgmt_vmName" {
  description = "Name of the VM resource in Azure"
  type        = string
  default     = "MT01"
}

variable "mgmt_computerName" {
  description = "NETBIOS computer name of the VM"
  type        = string
  default     = "MT01"
}

variable "mgmt_imagesku" {
  type        = string
  description = "Image SKU to use for the management server/jumphost"
  default     = "2022-Datacenter"
}

variable MGMT_backuppolicy {
  description = "Backup Policy to be used"
  type        = string
  default     = "BackupDaily-90Days"
}

variable "MGMT_rdp_whitelist_ips" {
  description =  "Additional IP numbers to whitelist for RDP"
  default     = []
  type        = list
}


############################################################
# Variables Module Shared Services
# Included
# v1.0.0
############################################################

variable "enable_update_management" {
  description = "Set to true to enable Update Management"
  type        = bool
  default     = false
}

variable "enable_change_tracking" {
  description = "Set to true to enable Change Tracking"
  type        = bool
  default     = false
}

variable "enable_alerting" {
  description = "Set to true to enable Alerting"
  type        = bool
  default     = false
}

variable "snet-shared_prefix" {
  description = "Subnet prefix for snet-shared"
  type        = list(string)
}

variable "alerting_deploy_dev_action_rule" {
  type = bool
  description = "When this is set to true, a action rule (processing rule) will be deployed that removes action groups 24/7"
}

variable "keyvault_user_object_ids" {
  description = "Supply the user object id's that need access permissions on the keyvault"
  type = list(string)
}

variable "keyvault_service_principal_ids" {
  description = "Supply the service principal object id's that need access permissions on the keyvault"
  type = list(string)
}

############################################################
# Variables Module Shared Resources
# Included
# v1.0.0
############################################################
variable "trusted_spoke_vnet" {
  description = "Trusted VNETs for inbound security rule"
  default     = null
  type        = list(any)
}

############################################################
# Variables ADDS Identity Services
# tf-azure-adds
# v0.0.1b
############################################################

variable "deploy_identity" {
  description = "Set to true to create an IdP"
  type        = bool
  default     = false
}

variable "deploy_adds" {
  description = "Set to true to create native adds domain controllers"
  type        = bool
  default     = false
}

variable "snet-identity_prefix" {
  description = "Subnet prefix for snet-identity"
  type        = list(string)
}

variable "adds_dc_ips" {
  description = "IP numbers for domain controllers to be assigned"
  type        = list(string)
}

variable "adds_domain_name" {
  description = "Domain Name"
  type        = string
}

variable "active_directory_netbios_name" {
  description = "The netbios name of the Active Directory domain, for example `contoso`"
  default     = "adds"
}

variable "first_dc_computer_name" {
  description = "NETBIOS computer name of primary domain controller VM"
  type        = string
}

variable "first_dc_vm_name" {
  description = "Name of primary domain controller resource in Azure"
  type        = string
}

variable "second_dc_computer_name" {
  description = "NETBIOS computer name of secondary domain controller VM"
  type        = string
}

variable "second_dc_vm_name" {
  description = "Name of secondary domain controller resource in Azure"
  type        = string
}

variable "adds_local_admin_acount" {
  description = "Account name used for local admin on deployed VM's"
  type        = string
  default     = "cladmin"
}

variable "adds_ad_username" {
  description = "Domain administrator account"
  type        = string
  default     = "cladmin"
}

variable "adds_ad_userpassword" {
  description = "Domain admin password current existing domain"
  type        = string
  default     = "None"
}


variable "adds_deployment_scenario" {
  description = "The deployment scenario of the environment"
  type        = string
  default     = "Greenfield"
}

variable "adds_vm_sku_size" {
  description = "Default sku to be used by ADDS VM's"
  type        = string
  default     = "Standard_B2ms"
}

variable "adds_resourcesuffix" {
  description = "The resource suffix added after resource groups to support multiple deployments in one subscription"
  type        = string
  default     = "001"
}

variable "adds_storage_account_type" {
  description = "The type of storage account used for osDisk"
  type        = string
  default     = "Standard_LRS"
}

variable "adds_image_publisher" {
  description = "Supply the publisher of the OS for the domain controller"
  type        = string
  default     = "MicrosoftWindowsServer"
}

variable "adds_image_offer" {
  description = "Supply the offer of the OS for the domain controller"
  type        = string
  default     = "WindowsServer"
}

variable "adds_image_sku" {
  description = "Supply the sku of the domain controller OS"
  type        = string
  default     = "2019-Datacenter"
}

variable "adds_image_version" {
  description = "Supply the version of the OS for the domain controller"
  type        = string
  default     = "latest"
}

variable "adds_cbx_sla" {
  description = "The Claranet SLA applicable for this resource"
  type        = string
  default     = "8x5"
}

variable "adds_cbx_billable" {
  description = "The Claranet billable model applicable for this resource"
  type        = string
  default     = "Billable-Dynamic"
}

variable "adds_cbx_owner" {
  description = "The Claranet owner applicable for this resource"
  type        = string
  default     = "Cloud"
}

variable "adds_cbx_backup_policy" {
  description = "The Claranet backup policy applicable for this resource"
  type        = string
  default     = "BackupDaily-30Days"
}

variable "adds_cbx_product" {
  description = "The Claranet product applicable for this resource"
  type        = string
  default     = "Public-Cloud-Standard"
}

variable "adds_cbx_update_group" {
  description = "The Claranet update group applicable for this resource"
  type        = string
  default     = "1"
}

############################################################
# Variables Module Shared Fileserver
# included
# v1.0.0
############################################################
variable "deploy_sharedfileserver" {
  description = "Set to true to the shared fileserver resources"
  type        = bool
  default     = false
}
variable "fileserver_resource_group" {
  description = "Name of the resource group to deploy the resource in"
  type        = string
  default     = "rg-sharedresources-weu"
}
variable "fileserver_servername" {
  description = "Name of the server"
  type        = string
  default     = "FS01"
}
variable "fileserver_skusize" {
  description = "SKU to be used"
  type        = string
  default     = "Standard_B2ms"
}
variable "fileserver_ip" {
  description = "IP for Fileserver"
  type        = string
}
variable "fileserver_data_disk1_size" {
  description = "Fileserver Data disk size"
  type        = string
}
variable "fileserver_image_sku" {
  description = "Specifies the SKU of the image used to create the VM(s)"
  type        = string
  default     = "2022-Datacenter"
}
variable "fileserver_environment" {
  description = "Environment (Production/Test/Acceptance/Development)"
  type        = string
  default     = "None"
}

variable "deploy_webdav" {
  description = "Set to true to deploy webdav"
  type        = bool
  default     = false
}


############################################################
# Variables Module Printix
# tf-azure-printix
# v1.0.0
############################################################

variable "deploy_printix" {
  description = "Set to true to create printix storage account"
  type        = bool
  default     = false
}

############################################################
# Variables Module Fortigate
# tf-azure-fortigate
# v1.0.8
############################################################

variable "deploy_fortigate" {
  description = "Set to true to create Fortigate resources"
  type        = bool
  default     = false
}

variable "fortigate_publiccidr" {
  default = "10.1.0.0/24"
}

variable "fortigate_privatecidr" {
  default = "fortigate_privatecidr"
}

variable "fortigate_license_file" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "license.txt"
}

variable "fortigate_license_type" {
  default = "byol" # Can be byol or payg
}

variable "fortigate_external_ip" {
  description = "fortigate_external_ip"
  type        = string
}

variable "fortigate_internal_ip" {
  description = "IP to use on port2 (internal)"
  type        = string
}

variable "fortigate_address_prefix" {
  description = "Route subnet"
}

variable "fortigate_version" {
  type        = string
  description = "FortiOS version to use"
  default     = "7.0.12"

}
variable "fortigate_size" {
  type    = string
  default = "Standard_DS1_v2"
}


############################################################
# Variables Bastion
# tf-azure-bastion
# v1.0.0
############################################################

variable "deploy_bastion" {
  description = "Module switch"
  type        = bool
  default     = false
}

variable "bastion_subnet_prefix" {
  description = "Subnet prefix for bastion host"
  type        = string
  default     = null
}

variable "bastion_sku" {
  description = "SKU for bastion host"
  type        = string
  default     = "Basic" # Can be Basic or Standard
}

variable "bastion_copy_paste_enabled" {
  description = "Enable or Disable copy paste option for Bastion host."
  type        = string
  default     = true # Can be true or false.
}

variable "bastion_file_copy_enabled" {
  description = "SKU for bastion host"
  type        = string
  default     = false # Can be true or false
}
