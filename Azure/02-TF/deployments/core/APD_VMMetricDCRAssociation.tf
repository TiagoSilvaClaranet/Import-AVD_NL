resource "azurerm_policy_definition" "policy_vmmetrics_dcr_association" {
  name                = "[CBX] Associate VM Metric DCR with Virtual Machines"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "[CBX] Configure Virtual Machines to be associated with a VM Metric Data Collection Rule or a Data Collection Endpoint"
  description         = "Deploy Association to link Windows virtual machines to the specified Data Collection Rule or the specified Data Collection Endpoint. The list of locations and OS images are updated over time as support is increased."
  management_group_id = azurerm_management_group.level_1["intermediate_root"].id


  metadata    = file("${path.module}/policydefinitions/DcrAssociation/vmMetricsDefinition/metadata.json")
  policy_rule = file("${path.module}/policydefinitions/DcrAssociation/vmMetricsDefinition/policy.json")
  parameters  = file("${path.module}/policydefinitions/DcrAssociation/vmMetricsDefinition/parameters.json")
}
