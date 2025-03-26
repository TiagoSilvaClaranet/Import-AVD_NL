# Assigns backup policy based on VM tag on subscription level

# Steps
# - Retrieve Policy Definition Id of the custom definition
# - Assign policy definition to the subscription
# - Add needed roles to the System Managed Identity of the policy assignment
# - Create a remediation task for the policy

################################# 
# Policy Assignment
#################################   
resource "azurerm_management_group_policy_assignment" "azurepolicy_backupdaily-30days" {
  
  #name                 = "[CBX] VM Backup Policy based on BackupPolicy Tag-BackupDaily-30d"
  name                 = "cbxvmbackup30days" # When assigning to management group name is max 24 chars
  management_group_id  = data.azurerm_management_group.mg-platform.id

  policy_definition_id = data.azurerm_policy_definition.policy_vmbackupbytag.id
                         
  description          = "[CBX] VM Backup Policy based on BackupPolicy Tag - BackupDaily-30days"
  display_name         = "[CBX] VM Backup Policy based on BackupPolicy Tag - BackupDaily-30days"
  location             = var.location
  identity {
    type = "SystemAssigned"
  }

  metadata = <<METADATA
    {
    "category": "General"
    }
METADATA

  parameters = <<PARAMETERS
{
  "vaultLocation": {
    "value": "West Europe"
  },
  "inclusionTagName": {
    "value": "BackupPolicy"
  },
  "inclusionTagValue": {
    "value": [ "BackupDaily-30Days" ] 
  },
  "backupPolicyId": {
    "value": "${azurerm_backup_policy_vm.DailyBackup-30Days.id}"
  }
}
PARAMETERS
}

################################# 
# Policy role assignments
################################# 
# TODO Add roles to SystemAssigned Identity
resource "azurerm_role_assignment" "azurepolicy_backupdaily-30days_identity_role_virtualmachinecontributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_management_group_policy_assignment.azurepolicy_backupdaily-30days.identity[0].principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "azurepolicy_backupdaily-30days_identity_role_backupcontributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Backup Contributor"
  principal_id         = azurerm_management_group_policy_assignment.azurepolicy_backupdaily-30days.identity[0].principal_id
  skip_service_principal_aad_check = true
}



################################# 
# Policy remediation task
################################# 
# Create Remediation Task to get all existing resources in compliant state
resource "azurerm_subscription_policy_remediation" "azurepolicy_backupdaily-30days_remediation" {
  name                            = "[cbx] vm backup policy based on backuppolicy tag - 30d initial remediation" #name cannot contain upper case letters
  subscription_id                 = data.azurerm_subscription.current.id
  policy_assignment_id            = azurerm_management_group_policy_assignment.azurepolicy_backupdaily-30days.id
  #policy_definition_reference_id  = azurerm_policy_definition.backupbytag.id # Do not set this property or else the remediation task will not be shown in the Azure Portal
  #location_filters                = ["westeurope"]
  resource_discovery_mode         = "ReEvaluateCompliance"  # ReEvaluateCompliance to check all resources in the scope for compliance
  depends_on                      = [azurerm_role_assignment.azurepolicy_backupdaily-30days_identity_role_virtualmachinecontributor, azurerm_role_assignment.azurepolicy_backupdaily-30days_identity_role_backupcontributor]
}
