resource "azurerm_policy_definition" "policy_Linuxmonitoringagent" {
  name                = "[CBX] Install Microsoft Linux Monitoring Agent"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "[CBX] Install Microsoft Linux Monitoring Agent"
  management_group_id = azurerm_management_group.level_1["intermediate_root"].id

  metadata    = file("${path.module}/policydefinitions/MicrosoftLinuxMonitoringAgent/metadata.json")
  policy_rule = file("${path.module}/policydefinitions/MicrosoftLinuxMonitoringAgent/policy.json")
  parameters  = file("${path.module}/policydefinitions/MicrosoftLinuxMonitoringAgent/parameters.json")
}
