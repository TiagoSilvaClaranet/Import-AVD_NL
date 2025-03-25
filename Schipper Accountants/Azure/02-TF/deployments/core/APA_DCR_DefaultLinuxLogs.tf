# Assigns the default Linux VM DCR to all Linux VM's in the Azure Subscription

# Steps
# - Retrieve Policy Definition Id of the custom definition
# - Assign policy definition to the subscription
# - Add needed roles to the System Managed Identity of the policy assignment
# - Create a remediation task for the policy

# 10x5 Monitoring
# Assign policy definition to the subscription
resource "azurerm_management_group_policy_assignment" "policy_linuxlogsdcr_assignment-10x5" {
  for_each              = local.platform_and_lz_management_group_ids

  name                 = "dcrlinuxlogs10x5" # When assigning to management group name is max 24 chars
  management_group_id  = each.value

  policy_definition_id = azurerm_policy_definition.policy_linuxlogs_dcr_association-10x5.id
                         
  description          = "[CBX] Assign default Linux Logs DCR to VMs 10x5"
  display_name         = "[CBX] Assign default Linux Logs DCR to VMs 10x5"
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
      "value" = "${var.monitoring-dcr-linuxlogs-10x5}"
      }
    }
  )
  
}

# Add needed roles to the System Managed Identity of the policy assignment
# Needs 'Log Analytics Contributor' and 'Monitoring Contributor' roles
resource "azurerm_role_assignment" "policy_linuxlogsdcr_assignment_identity_role_loganalyticscontributor-10x5" {
  for_each             = local.platform_and_lz_management_group_ids
  scope                = each.value
  role_definition_name = "Log Analytics Contributor"
  principal_id         = azurerm_management_group_policy_assignment.policy_linuxlogsdcr_assignment-10x5[each.key].identity[0].principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "policy_linuxlogsdcr_assignment_identity_role_monitoringcontributor-10x5" {
  for_each             = local.platform_and_lz_management_group_ids
  scope                = each.value
  role_definition_name = "Monitoring Contributor"
  principal_id         = azurerm_management_group_policy_assignment.policy_linuxlogsdcr_assignment-10x5[each.key].identity[0].principal_id
  skip_service_principal_aad_check = true
}

# Also add role permissions for platform which contains the DCR (Need 'Microsoft.Insights/dataCollectionRules/read' permissions)
resource "azurerm_role_assignment" "policy_linuxlogsdcr_assignment_identity_role_monitoringreader_platform-10x5" {
  for_each             = local.platform_and_lz_management_group_ids
  scope                = azurerm_management_group.level_2["platform"].id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_management_group_policy_assignment.policy_linuxlogsdcr_assignment-10x5[each.key].identity[0].principal_id
  skip_service_principal_aad_check = true
}

# Create Remediation Task to get all existing resources in compliant state
resource "azurerm_management_group_policy_remediation" "policy_linuxlogsdcr_remediation-10x5" {
  for_each                        = local.platform_and_lz_management_group_ids
  name                            = "[cbx] assign linux logs dcr - initial remediation 10x5" #name cannot contain upper case letters
  management_group_id             = each.value
  policy_assignment_id            = azurerm_management_group_policy_assignment.policy_linuxlogsdcr_assignment-10x5[each.key].id
  depends_on = [ azurerm_role_assignment.policy_linuxlogsdcr_assignment_identity_role_loganalyticscontributor-10x5, 
                 azurerm_role_assignment.policy_linuxlogsdcr_assignment_identity_role_monitoringcontributor-10x5,
                 azurerm_role_assignment.policy_linuxlogsdcr_assignment_identity_role_monitoringreader_platform-10x5
              ]
}

# 24x7 Monitoring
# Assign policy definition to the subscription
resource "azurerm_management_group_policy_assignment" "policy_linuxlogsdcr_assignment-24x7" {
  for_each             = local.platform_and_lz_management_group_ids

  name                 = "dcrlinuxlogs24x7" # When assigning to management group name is max 24 chars
  management_group_id  = each.value

  policy_definition_id = azurerm_policy_definition.policy_linuxlogs_dcr_association-24x7.id
                         
  description          = "[CBX] Assign default Linux Logs DCR to VMs 24x7"
  display_name         = "[CBX] Assign default Linux Logs DCR to VMs 24x7"
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
      "value" = "${var.monitoring-dcr-linuxlogs-24x7}"
      }
    }
  )
  
}

# Add needed roles to the System Managed Identity of the policy assignment
# Needs 'Log Analytics Contributor' and 'Monitoring Contributor' roles
resource "azurerm_role_assignment" "policy_linuxlogsdcr_assignment_identity_role_loganalyticscontributor-24x7" {
  for_each             = local.platform_and_lz_management_group_ids
  scope                = each.value
  role_definition_name = "Log Analytics Contributor"
  principal_id         = azurerm_management_group_policy_assignment.policy_linuxlogsdcr_assignment-24x7[each.key].identity[0].principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "policy_linuxlogsdcr_assignment_identity_role_monitoringcontributor-24x7" {
  for_each             = local.platform_and_lz_management_group_ids
  scope                = each.value
  role_definition_name = "Monitoring Contributor"
  principal_id         = azurerm_management_group_policy_assignment.policy_linuxlogsdcr_assignment-24x7[each.key].identity[0].principal_id
  skip_service_principal_aad_check = true
}

# Also add role permissions for platform which contains the DCR (Need 'Microsoft.Insights/dataCollectionRules/read' permissions)
resource "azurerm_role_assignment" "policy_linuxlogsdcr_assignment_identity_role_monitoringreader_platform-24x7" {
  for_each             = local.platform_and_lz_management_group_ids
  scope                = azurerm_management_group.level_2["platform"].id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_management_group_policy_assignment.policy_linuxlogsdcr_assignment-24x7[each.key].identity[0].principal_id
  skip_service_principal_aad_check = true
}


# Create Remediation Task to get all existing resources in compliant state
resource "azurerm_management_group_policy_remediation" "policy_linuxlogsdcr_remediation-24x7" {
  for_each                        = local.platform_and_lz_management_group_ids
  name                            = "[cbx] assign linux logs dcr - initial remediation 24x7" #name cannot contain upper case letters
  management_group_id             = each.value
  policy_assignment_id            = azurerm_management_group_policy_assignment.policy_linuxlogsdcr_assignment-24x7[each.key].id
  depends_on = [ azurerm_role_assignment.policy_linuxlogsdcr_assignment_identity_role_loganalyticscontributor-24x7, 
                 azurerm_role_assignment.policy_linuxlogsdcr_assignment_identity_role_monitoringcontributor-24x7,
                 azurerm_role_assignment.policy_linuxlogsdcr_assignment_identity_role_monitoringreader_platform-24x7
              ]
}