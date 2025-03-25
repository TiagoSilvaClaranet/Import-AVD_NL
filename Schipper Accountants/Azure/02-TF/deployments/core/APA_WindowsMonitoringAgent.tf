# Assigns the Windows VM Monitoring Agent policy to the VM

# Steps
# - Retrieve Policy Definition Id of the custom definition
# - Assign policy definition to the subscription
# - Add needed roles to the System Managed Identity of the policy assignment
# - Create a remediation task for the policy


resource "azurerm_management_group_policy_assignment" "policy_microsoftmonitoringagent_assignment" {
  for_each              = local.platform_and_lz_management_group_ids
  
  #name                 = "[CBX] Install Microsoft Monitoring Agent"
  name                 = "installwinmma" # When assigning to management group name is max 24 chars
  management_group_id  = each.value

  policy_definition_id = azurerm_policy_definition.policy_microsoftmonitoringagent.id
                         
  description          = "[CBX] Install Microsoft Monitoring Agent"
  display_name         = "[CBX] Install Microsoft Monitoring Agent"
  location             = var.location
  identity {
    type = "SystemAssigned"
  }

  metadata = <<METADATA
    {
    "category": "Monitoring"
    }
METADATA

  parameters = <<PARAMETERS
{
  "logAnalytics": {
    "value": "${var.monitoring-law}"
  }
}
PARAMETERS
}

# Add roles to the SystemAssigned Identity
resource "azurerm_role_assignment" "policy_microsoftmonitoringagent_assignment_identity_role_loganalyticscontributor" {
  for_each             = local.platform_and_lz_management_group_ids 

  scope                = azurerm_management_group.level_2["platform"].id # Currently assigned to the platform mg. Could be changed to the law instead
  role_definition_name = "Log Analytics Contributor"
  principal_id         = azurerm_management_group_policy_assignment.policy_microsoftmonitoringagent_assignment[each.key].identity[0].principal_id
  skip_service_principal_aad_check = true
}


# Create Remediation Task to get all existing resources in compliant state
resource "azurerm_management_group_policy_remediation" "policy_microsoftmonitoringagent_remediation" {
  for_each                        = local.platform_and_lz_management_group_ids

  name                            = "[cbx] install microsoft monitoring agent - initial remediation" #name cannot contain upper case letters
  management_group_id             = each.value
  policy_assignment_id            = azurerm_management_group_policy_assignment.policy_microsoftmonitoringagent_assignment[each.key].id
  #policy_definition_reference_id  = azurerm_policy_definition.policy_microsoftmonitoringagent.id # Do not set this property or else the remediation task will not be shown in the Azure Portal
  #location_filters                = ["westeurope"]
  #resource_discovery_mode         = "ReEvaluateCompliance"  # ReEvaluateCompliance to check all resources in the scope for compliance
  depends_on                      = [azurerm_role_assignment.policy_microsoftmonitoringagent_assignment_identity_role_loganalyticscontributor]
}
