locals {
  name3 = "Metric Alert High CPU 24x7"
  definition3 = "[CBX] Deploy ${local.name3}"
  assignment3 = "[CBX] Assignment - ${local.name3}"
  remediation3 = "[cbx] remediation - ${lower(local.name3)}"
}

resource "azurerm_policy_definition" "policy_highcpu24x7" {
  name         = local.definition3
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = local.definition3
  
  metadata     = file("${path.module}/definition/metadata.json")
  policy_rule  = file("${path.module}/definition/high-cpu-24x7.json")
  
  parameters = <<PARAMETERS
  {
    "actionGroup" : {
      "type" : "array",
      "defaultValue": [
        {
          "actionGroupId" : "${var.mailActionGroupResourceId}",
          "webhookProperties" : {}
        },
        {
          "actionGroupId" : "${var.pagerDutyActionGroupResourceId}",
          "webhookProperties" : {}
        }
      ]
    }
  }
  PARAMETERS
}

# Create the policy assignment
resource "azurerm_subscription_policy_assignment" "policy_highcpu24x7_assignment" {
  
  name                 = local.assignment3
  subscription_id      = var.subscription_id

  #policy_definition_id = data.azurerm_policy_definition.policy_microsoftdependancyagentwithama.id
  policy_definition_id = azurerm_policy_definition.policy_highcpu24x7.id
                         
  description          = local.assignment3
  display_name         = local.assignment3
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
resource "azurerm_role_assignment" "policy_highcpu24x7_assignment_identity_role_loganalyticscontributor" {
  scope                = var.subscription_id
  #role_definition_name = "Monitoring Contributor"
  role_definition_name = "Contributor"
  principal_id         = azurerm_subscription_policy_assignment.policy_highcpu24x7_assignment.identity[0].principal_id
  skip_service_principal_aad_check = true
}

# Create Remediation Task to get all existing resources in compliant state
resource "azurerm_subscription_policy_remediation" "policy_highcpu24x7_remediation" {
  name                            = local.remediation3 #name cannot contain upper case letters
  subscription_id                 = var.subscription_id
  policy_assignment_id            = azurerm_subscription_policy_assignment.policy_highcpu24x7_assignment.id
  location_filters                = ["westeurope"]
  resource_discovery_mode         = "ReEvaluateCompliance"  # ReEvaluateCompliance to check all resources in the scope for compliance
  #depends_on                      = [azurerm_role_assignment.policy_microsoftdependancyagentwithama_assignment_identity_role_loganalyticscontribut]
}