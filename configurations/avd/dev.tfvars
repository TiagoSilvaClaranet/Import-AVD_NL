nlcnumber                       = "NLC000883" # Supply the NLC number
prefix                          = "schipper" # Used by Azure Resource VM name only
customer_short_name             = "schipper" # Enter customer short name
resource_group_name             = "rg-spoke-schipper-avd-sessionhosts-dev-weu-001" # Deploy session hosts resources in this resource group
avd_subnet_id                   = "/subscriptions/63cf28ad-7dcb-431b-a539-58a6e358db3d/resourceGroups/rg-spoke-schipper-network-prod-weu-001/providers/Microsoft.Network/virtualNetworks/vnet-spoke-schipper-prod-weu-001/subnets/snet-schipper_avd" # Place the session hosts in this subnet (Subnet is NOT deployed with avd-backend!) need to be added from the correct spoke or hub module

avd_host_pool_id                = "/subscriptions/63cf28ad-7dcb-431b-a539-58a6e358db3d/resourceGroups/rg-spoke-schipper-avd-prod-weu-001/providers/Microsoft.DesktopVirtualization/hostPools/vdpool-generic-dev-weu-001" # We unfortunately need to specify the Host Pool ID because there is still no Terraform Data object to retrieve it (make sure hostPools is with capital P)
azure_image_gallery_resource_id = "/subscriptions/63cf28ad-7dcb-431b-a539-58a6e358db3d/resourceGroups/rg-spoke-schipper-avd-prod-weu-001/providers/Microsoft.Compute/galleries/sigavdprodweu65fv" # Resource id of the Azure Compute Gallery used

vm_size                         = "Standard_B2s" # Specify the VM Size to use to deploy the new session hosts
storage_account_type            = "Standard_LRS" # Standard_LRS, StandardSSD_LRS, Premium_LRS

domain_name                     = "schgoe.local" # Specify the domain to where the session hosts should be joined (ex. adds.dummy.domain)
vm_join_account                 = "vmjoiner" # User Principal Name of the account used to join the vm
avd_ou_path                     = "OU=dev,OU=AVD,OU=Servers,OU=Maintenance,DC=schgoe,DC=local" # Supply the OU path where the avd session hosts should be added (ex. OU=AVD,OU=Azure,DC=adds,DC=dummy,DC=domain)

log_analytics_workspace_id      = "1f0cf04f-6716-42f3-b0e9-4a746935edb9" # The log analytics workspace id, not the resource id!
keyvault_resource_id            = "/subscriptions/63cf28ad-7dcb-431b-a539-58a6e358db3d/resourceGroups/rg-shared-weu-001/providers/Microsoft.KeyVault/vaults/kv000883sharedprodweu001" # Supply the shared keyvault name where the credentials are stored

enable_dcr                      = false # Set to false if you don't want to assign data collection rules for monitoring
dcr_id                          = "/subscriptions/63cf28ad-7dcb-431b-a539-58a6e358db3d/resourceGroups/rg-spoke-schipper-avd-prod-weu-001/providers/Microsoft.Insights/dataCollectionRules/dcr-avd-sessionhost-monitoring" # Supply the resource id of the data collection rule for session host monitoring (located in avd-backend resource group)
dcr-vmi_id                      = "/subscriptions/63cf28ad-7dcb-431b-a539-58a6e358db3d/resourceGroups/rg-spoke-schipper-avd-prod-weu-001/providers/Microsoft.Insights/dataCollectionRules/dcr-avd-vminsights" # Supply the resource id of the data collection rule for session host vm insights (located in avd-backend resource group)
