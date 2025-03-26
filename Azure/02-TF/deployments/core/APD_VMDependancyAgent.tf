resource "azurerm_policy_definition" "policy_microsoftdependancyagent" {
  name                = "[CBX] Install Microsoft Dependancy Agent (AMA mode)"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "[CBX] Install Microsoft Dependancy Agent (AMA mode)"
  description         = "Deploys the Microsoft Dependancy Agent in AMA mode"
  management_group_id = azurerm_management_group.level_1["intermediate_root"].id

  metadata    = file("${path.module}/policydefinitions/MicrosoftDependancyAgent/metadata.json")
  policy_rule = file("${path.module}/policydefinitions/MicrosoftDependancyAgent/policy.json")
  parameters  = file("${path.module}/policydefinitions/MicrosoftDependancyAgent/parameters.json")
}
