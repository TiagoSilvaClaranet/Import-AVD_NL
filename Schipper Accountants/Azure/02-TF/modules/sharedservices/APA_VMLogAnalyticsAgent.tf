# Steps
# - Retrieve Policy Definition Id of the custom definition
# - Assign policy definition to the subscription
# - Add needed roles to the System Managed Identity of the policy assignment
# - Create a remediation task for the policy

# Get data object for exiting 'Deploy - Configure Log Analytics extension to be enabled on Windows virtual machines' auzre policy definition
data "azurerm_policy_definition" "policy_microsoftloganalyticsagent" {
  display_name = "Deploy - Configure Log Analytics extension to be enabled on Windows virtual machines"
}

resource "azurerm_management_group_policy_assignment" "policy_microsoftloganalyticsagent_assignment" {
  
  #name                 = "[CBX] Deploy - Configure Log Analytics extension"
  name                 = "cbxdeploylawext" # When assigning to management group name is max 24 chars
  management_group_id  = data.azurerm_management_group.mg-platform.id

  policy_definition_id = data.azurerm_policy_definition.policy_microsoftloganalyticsagent.id
                         
  description          = "[CBX] Deploy - Configure Log Analytics extension to be enabled on Windows virtual machines"
  display_name         = "[CBX] Deploy - Configure Log Analytics extension to be enabled on Windows virtual machines"
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
    "value": "${azurerm_log_analytics_workspace.log-shared.id}"
  }
}
PARAMETERS
  
}

# Add roles to the SystemAssigned Identity
resource "azurerm_role_assignment" "policy_microsoftloganalyticsagent_assignment_identity_role_loganalyticscontributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Log Analytics Contributor"
  principal_id         = azurerm_management_group_policy_assignment.policy_microsoftloganalyticsagent_assignment.identity[0].principal_id
  skip_service_principal_aad_check = true
}



# Create Remediation Task to get all existing resources in compliant state
resource "azurerm_subscription_policy_remediation" "policy_microsoftloganalyticsagent_remediation" {
  name                            = "[cbx] configure log analytics agent - initial remediation" #name cannot contain upper case letters
  subscription_id                 = data.azurerm_subscription.current.id
  policy_assignment_id            = azurerm_management_group_policy_assignment.policy_microsoftloganalyticsagent_assignment.id
  #policy_definition_reference_id  = azurerm_policy_definition.policy_microsoftloganalyticsagent.id # Do not set this property or else the remediation task will not be shown in the Azure Portal
  #location_filters                = ["westeurope"]
  resource_discovery_mode         = "ReEvaluateCompliance"  # ReEvaluateCompliance to check all resources in the scope for compliance
  #depends_on                      = [azurerm_role_assignment.policy_microsoftloganalyticsagent_assignment_identity_role_loganalyticscontributor]
}
