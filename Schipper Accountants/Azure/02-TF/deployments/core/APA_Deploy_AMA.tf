# Deploy Azure Monitoring Agent (AMA) to all Windows Virtual Machines
# Deploys the policy to platform and landing-zones management groups

# Steps
# - Retrieve Policy Definition Id of the out-of-the-box definition
# - Assign policy definition to the subscription
# - Add needed roles to the System Managed Identity of the policy assignment
# - Create a remediation task for the policy

# Retrieve Policy Definition Id of the out-of-the-box definition
data "azurerm_policy_definition" "policy_deployama" {
  display_name = "Configure Windows virtual machines to run Azure Monitor Agent using system-assigned managed identity"
}

# Assign policy definition to the subscription
resource "azurerm_management_group_policy_assignment" "policy_deployama_assignment" {
  for_each              = local.platform_and_lz_management_group_ids

  name                  = "deployama" # When assigning to management group name is max 24 chars
  management_group_id   = each.value

  policy_definition_id  = data.azurerm_policy_definition.policy_deployama.id
                         
  description           = "[CBX] Configure Windows virtual machines to run Azure Monitor Agent using system-assigned managed identity"
  display_name          = "[CBX] Configure Windows virtual machines to run Azure Monitor Agent using system-assigned managed identity"
  location              = var.location  # Location where the SMI is created in

  identity {
    type = "SystemAssigned"
  }

  metadata = <<METADATA
    {
    "category": "Monitoring"
    }
METADATA
}

# Add needed roles to the System Managed Identity of the policy assignment
# Needs 'Virtual Machine Contributor'  roles
resource "azurerm_role_assignment" "policy_deployama_assignment_identity_role_virtualmachinecontributor" {
  for_each             = local.platform_and_lz_management_group_ids

  scope                = each.value
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_management_group_policy_assignment.policy_deployama_assignment[each.key].identity[0].principal_id
  skip_service_principal_aad_check = true
}

# Create Remediation Task to get all existing resources in compliant state
resource "azurerm_management_group_policy_remediation" "policy_deployama_remediation" {
  for_each                        = local.platform_and_lz_management_group_ids

  name                            = "[cbx] deploy ama - initial remediation" #name cannot contain upper case letters
  management_group_id             = each.value
  policy_assignment_id            = azurerm_management_group_policy_assignment.policy_deployama_assignment[each.key].id
  depends_on                      = [azurerm_role_assignment.policy_deployama_assignment_identity_role_virtualmachinecontributor]
}
