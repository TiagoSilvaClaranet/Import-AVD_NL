locals {
  name2 = "Metric Alert High Memory 10x5"
  definition2 = "[CBX] Deploy ${local.name2}"
  assignment2 = "[CBX] Assignment - ${local.name2}"
  remediation2 = "[cbx] remediation - ${lower(local.name2)}"
}

resource "azurerm_policy_definition" "policy_highmemory10x5" {
  name         = local.definition2
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = local.definition2
  
  metadata     = file("${path.module}/definition/metadata.json")
  policy_rule  = file("${path.module}/definition/high-memory-10x5.json")

  parameters = <<PARAMETERS
  {
    "actionGroup" : {
      "type" : "array",
      "defaultValue": [
        {
          "actionGroupId" : "${var.mailActionGroupResourceId}",
          "webhookProperties" : {}
        }
      ]
    }
  }
  PARAMETERS
}

# Create the policy assignment
resource "azurerm_subscription_policy_assignment" "policy_highmemory10x5_assignment" {
  
  name                 = local.assignment2
  subscription_id      = var.subscription_id

  #policy_definition_id = data.azurerm_policy_definition.policy_microsoftdependancyagentwithama.id
  policy_definition_id = azurerm_policy_definition.policy_highmemory10x5.id
                         
  description          = local.assignment2
  display_name         = local.assignment2
  location             = "West Europe"
  identity {
    type = "SystemAssigned"
  }

  metadata = <<METADATA
    {
    "category": "Monitoring"
    }
METADATA
}

# Add the needed roles to the SystemAssigned Identity of the policy assignment
resource "azurerm_role_assignment" "policy_highmemory10x5_assignment_identity_role_loganalyticscontributor" {
  scope                = var.subscription_id
  #role_definition_name = "Monitoring Contributor"
  role_definition_name = "Contributor"
  principal_id         = azurerm_subscription_policy_assignment.policy_highmemory10x5_assignment.identity[0].principal_id
  skip_service_principal_aad_check = true
}

# Create Remediation Task to get all existing resources in compliant state
resource "azurerm_subscription_policy_remediation" "policy_highmemory10x5_remediation" {
  name                            = local.remediation2 #name cannot contain upper case letters
  subscription_id                 = var.subscription_id
  policy_assignment_id            = azurerm_subscription_policy_assignment.policy_highmemory10x5_assignment.id
  location_filters                = ["westeurope"]
  resource_discovery_mode         = "ReEvaluateCompliance"  # ReEvaluateCompliance to check all resources in the scope for compliance
  #depends_on                      = [azurerm_role_assignment.policy_microsoftdependancyagentwithama_assignment_identity_role_loganalyticscontribut]
}
