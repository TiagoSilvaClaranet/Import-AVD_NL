nlcnumber                       = "NLC000883"
prefix                          = "hb-vdsh" # Used by Azure Resource VM name only
resource_group_name             = "rg-spoke-hb-avd-sessionhosts-prd-weu-001" # Deploy session hosts resources in this resource group
avd_subnet_id                   = "/subscriptions/63cf28ad-7dcb-431b-a539-58a6e358db3d/resourceGroups/rg-spoke-hb-network-prod-weu-001/providers/Microsoft.Network/virtualNetworks/vnet-spoke-hb-prod-weu-001/subnets/snet-hb_avd" # Place the session hosts in this subnet

avd_host_pool_name              = "vdpool-generic-prd-weu-001" # Add session hosts to this Host Pool
avd_host_pool_id                = "/subscriptions/63cf28ad-7dcb-431b-a539-58a6e358db3d/resourceGroups/rg-spoke-hb-avd-prod-weu-001/providers/Microsoft.DesktopVirtualization/hostPools/vdpool-generic-prd-weu-001" # We unfortunately need to specify the Host Pool ID because there is still no Terraform Data object to retrieve it
#avd_hostpool_registration_token = null

source_image_id                 = "/subscriptions/63cf28ad-7dcb-431b-a539-58a6e358db3d/resourceGroups/rg-spoke-hb-avd-prod-weu-001/providers/Microsoft.Compute/galleries/sigavdprodweuwmb8/images/Spoke-AVD-Golden-Image-Basic" # Specify the SIG image to use

vm_size                         = "Standard_B2s" # Specify the VM Size to use to deploy the new session hosts
storage_account_type            = "Standard_LRS" # Standard_LRS, StandardSSD_LRS, Premium_LRS

domain_name                     = "schgoe.local"
domain_user_upn                 = "vmjoiner"
domain_user_password            = "the password is retrieved from the keyvault"
avd_ou_path                     = "OU=HB-PRD,OU=AVD,OU=Servers,OU=Maintenance,DC=schgoe,DC=local"

avd_host_pool_size              = 1 # Number of session hosts to deploy
avd_starting_offset             = 1 # Start numbering session hosts at this number

log_analytics_workspace_id      = "1f0cf04f-6716-42f3-b0e9-4a746935edb9"
log_analytics_workspace_key     = "the password is retrieved from the keyvault"

shared_keyvault_name            = "kv000883sharedprodweu001"
shared_keyvault_rg              = "rg-shared-weu-001"

dcr_id                          = "/subscriptions/63cf28ad-7dcb-431b-a539-58a6e358db3d/resourceGroups/rg-spoke-hb-avd-prod-weu-001/providers/Microsoft.Insights/dataCollectionRules/dcr-avd-sessionhost-monitoring"
dcr-vmi_id                      = "/subscriptions/63cf28ad-7dcb-431b-a539-58a6e358db3d/resourceGroups/rg-spoke-hb-avd-prod-weu-001/providers/Microsoft.Insights/dataCollectionRules/dcr-avd-vminsights"
  