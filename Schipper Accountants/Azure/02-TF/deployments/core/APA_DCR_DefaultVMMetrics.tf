# Assigns the default Windows VM DCR to all Windows VM's in the Azue Subscription

# Steps
# - Retrieve Policy Definition Id of the custom definition
# - Assign policy definition to the subscription
# - Add needed roles to the System Managed Identity of the policy assignment
# - Create a remediation task for the policy

# Assign policy definition to the subscription
resource "azurerm_management_group_policy_assignment" "policy_vmmetricsdcr_assignment" {
  for_each              = local.platform_and_lz_management_group_ids
  
  name                 = "assigndcrmtvmmetrics" # When assigning to management group name is max 24 chars

  management_group_id  = each.value

  policy_definition_id = azurerm_policy_definition.policy_vmmetrics_dcr_association.id
                         
  description          = "[CBX] Assign default Metric DCR to VMs"
  display_name         = "[CBX] Assign default Metric DCR to VMs"
  location             = var.location
  identity {
    type = "SystemAssigned"
  }

  metadata = jsonencode(
    {
    "category" = "Monitoring"
    }
  )
  parameters = jsonencode(
    {
      "dcrResourceId" = {
      "value" = "${var.monitoring-dcr-windows}"
      }
    }
  )
  
}

# Add needed roles to the System Managed Identity of the policy assignment
# Needs 'Log Analytics Contributor' and 'Monitoring Contributor' roles
resource "azurerm_role_assignment" "policy_vmmetricsdcr_assignment_identity_role_loganalyticscontributor" {
  for_each              = local.platform_and_lz_management_group_ids
  scope                = each.value
  role_definition_name = "Log Analytics Contributor"
  principal_id         = azurerm_management_group_policy_assignment.policy_vmmetricsdcr_assignment[each.key].identity[0].principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "policy_vmmetricsdcr_assignment_identity_role_monitoringcontributor" {
  for_each              = local.platform_and_lz_management_group_ids
  scope                = each.value
  role_definition_name = "Monitoring Contributor"
  principal_id         = azurerm_management_group_policy_assignment.policy_vmmetricsdcr_assignment[each.key].identity[0].principal_id
  skip_service_principal_aad_check = true
}

# Also add role permissions for platform which contains the DCR (Need 'Microsoft.Insights/dataCollectionRules/read' permissions)
resource "azurerm_role_assignment" "policy_vmmetricsdcr_assignment_identity_role_monitoringreader_platform" {
  for_each              = local.platform_and_lz_management_group_ids
  scope                = azurerm_management_group.level_2["platform"].id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_management_group_policy_assignment.policy_vmmetricsdcr_assignment[each.key].identity[0].principal_id
  skip_service_principal_aad_check = true
}

# Create Remediation Task to get all existing resources in compliant state
resource "azurerm_management_group_policy_remediation" "policy_vmmetricsdcr_remediation" {
  for_each                        = local.platform_and_lz_management_group_ids
  name                            = "[cbx] assign vm metric dcr - initial remediation" #name cannot contain upper case letters
  management_group_id             = each.value
  policy_assignment_id            = azurerm_management_group_policy_assignment.policy_vmmetricsdcr_assignment[each.key].id
  depends_on = [ azurerm_role_assignment.policy_vmmetricsdcr_assignment_identity_role_loganalyticscontributor, 
                 azurerm_role_assignment.policy_vmmetricsdcr_assignment_identity_role_monitoringcontributor,
                 azurerm_role_assignment.policy_vmmetricsdcr_assignment_identity_role_monitoringreader_platform
              ]
}

