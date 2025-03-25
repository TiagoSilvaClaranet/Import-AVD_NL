resource "azurerm_policy_definition" "policy_windowslogs_dcr_association-10x5" {
  name                = "[CBX] Associate Windows Logs DCR with Virtual Machines 10x5"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "[CBX] Configure Virtual Machines to be associated with Windows Logs DCR Data Collection Rule or a Data Collection Endpoint 10x5"
  description         = "Deploy Association to link Windows virtual machines to the specified Data Collection Rule or the specified Data Collection Endpoint. The list of locations and OS images are updated over time as support is increased."
  management_group_id = azurerm_management_group.level_1["intermediate_root"].id


  metadata    = file("${path.module}/policydefinitions/DcrAssociation/windowsLogsDefinition/metadata.json")
  policy_rule = file("${path.module}/policydefinitions/DcrAssociation/windowsLogsDefinition/policy-10x5.json")
  parameters  = file("${path.module}/policydefinitions/DcrAssociation/windowsLogsDefinition/parameters.json")
}

resource "azurerm_policy_definition" "policy_windowslogs_dcr_association-24x7" {
  name                = "[CBX] Associate Windows Logs DCR with Virtual Machines 24x7"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "[CBX] Configure Virtual Machines to be associated with Windows Logs DCR Data Collection Rule or a Data Collection Endpoint 24x7"
  description         = "Deploy Association to link Windows virtual machines to the specified Data Collection Rule or the specified Data Collection Endpoint. The list of locations and OS images are updated over time as support is increased."
  management_group_id = azurerm_management_group.level_1["intermediate_root"].id


  metadata    = file("${path.module}/policydefinitions/DcrAssociation/windowsLogsDefinition/metadata.json")
  policy_rule = file("${path.module}/policydefinitions/DcrAssociation/windowsLogsDefinition/policy-24x7.json")
  parameters  = file("${path.module}/policydefinitions/DcrAssociation/windowsLogsDefinition/parameters.json")
}
