# Assigns the VM Insights VM DCR to all VM's in the Azure Subscription
# The DCR is defined in the platform azure monitor configuration

# Steps
# - Assign policy definition to the subscription
# - Add needed roles to the System Managed Identity of the policy assignment
# - Create a remediation task for the policy

# Assign policy definition to the subscription
resource "azurerm_management_group_policy_assignment" "policy_vminsights_dcr_assignment" {
  for_each              = local.platform_and_lz_management_group_ids
  
  #name                 = "[CBX] Assign VM Insights DCR to Windows VMs"
  name                 = "assignvminsightswinvm" # When assigning to management group name is max 24 chars
  management_group_id  = each.value

  policy_definition_id = azurerm_policy_definition.policy_vmmetrics_dcr_association.id
                         
  description          = "[CBX] Assign VM Insights DCR to VMs"
  display_name         = "[CBX] Assign VM Insights DCR to VMs"
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
      #"value" = "${azurerm_monitor_data_collection_rule.dcr-vminsights.id}"
      # Hardcoded DCR id from the DCR defined in the HUB
      # Make this a variable to be passed?
      #"value" = "/subscriptions/63daa892-077e-4061-8ff1-1b3cfc75d6ad/resourceGroups/rg-shared-weu-001/providers/Microsoft.Insights/dataCollectionRules/dcr-vminsights"
      "value" = "${var.monitoring-dcr-vminsights}"
      }
    }
  )
  
}

# Add needed roles to the System Managed Identity of the policy assignment
# Needs 'Log Analytics Contributor' and 'Monitoring Contributor' roles

resource "azurerm_role_assignment" "policy_vminsights_dcr_assignment_identity_role_loganalyticscontributor" {
  for_each              = local.platform_and_lz_management_group_ids
  scope                = each.value
  role_definition_name = "Log Analytics Contributor"
  principal_id         = azurerm_management_group_policy_assignment.policy_vminsights_dcr_assignment[each.key].identity[0].principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "policy_vminsights_dcr_assignment_identity_role_monitoringcontributor" {
  for_each              = local.platform_and_lz_management_group_ids
  scope                = each.value
  role_definition_name = "Monitoring Contributor"
  principal_id         = azurerm_management_group_policy_assignment.policy_vminsights_dcr_assignment[each.key].identity[0].principal_id
  skip_service_principal_aad_check = true
}

# Also add role permissions for platform which contains the DCR (Need 'Microsoft.Insights/dataCollectionRules/read' permissions)
resource "azurerm_role_assignment" "policy_vminsights_dcr_assignment_identity_role_monitoringreader_platform" {
  for_each              = local.platform_and_lz_management_group_ids
  #scope                = data.azurerm_subscription.current.id
  scope                = azurerm_management_group.level_2["platform"].id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_management_group_policy_assignment.policy_vminsights_dcr_assignment[each.key].identity[0].principal_id
  skip_service_principal_aad_check = true
}

# Create Remediation Task to get all existing resources in compliant state
resource "azurerm_management_group_policy_remediation" "policy_assign_dcr_vminsights_remediation" {
  for_each                        = local.platform_and_lz_management_group_ids
  name                            = "[cbx] assign vminsights dcr - initial remediation" #name cannot contain upper case letters
  management_group_id             = each.value
  policy_assignment_id            = azurerm_management_group_policy_assignment.policy_vminsights_dcr_assignment[each.key].id
  #location_filters                = ["westeurope"]
  #resource_discovery_mode         = "ReEvaluateCompliance"  # ReEvaluateCompliance to check all resources in the scope for compliance
  depends_on                      = [
                                      azurerm_role_assignment.policy_vminsights_dcr_assignment_identity_role_loganalyticscontributor,
                                      azurerm_role_assignment.policy_vminsights_dcr_assignment_identity_role_monitoringcontributor,
                                      azurerm_role_assignment.policy_vminsights_dcr_assignment_identity_role_monitoringreader_platform
                                     ]
}
