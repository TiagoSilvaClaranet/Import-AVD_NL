resource "azurerm_policy_definition" "policy_microsoftmonitoringagent" {
  name                = "[CBX] Install Microsoft Monitoring Agent"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "[CBX] Install Microsoft Monitoring Agent"
  management_group_id = azurerm_management_group.level_1["intermediate_root"].id

  metadata    = file("${path.module}/policydefinitions/MicrosoftMonitoringAgent/metadata.json")
  policy_rule = file("${path.module}/policydefinitions/MicrosoftMonitoringAgent/policy.json")
  parameters  = file("${path.module}/policydefinitions/MicrosoftMonitoringAgent/parameters.json")
}
