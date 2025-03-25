resource "azurerm_policy_definition" "policy_vmbackupbytag" {
  name                = "[CBX] VM Backup Policy based on BackupPolicy Tag"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "[CBX] VM Backup Policy based on BackupPolicy Tag"
  description         = "Enforce backup for all virtual machines by backing them up to an existing central recovery services vault in the same location and subscription as the virtual machine. Doing this is useful when there is a central team in your organization managing backups for all resources in a subscription. You can optionally include virtual machines containing a specified tag to control the scope of assignment. See https://aka.ms/AzureVMCentralBackupIncludeTag"
  management_group_id = azurerm_management_group.level_1["intermediate_root"].id

  metadata    = file("${path.module}/policydefinitions/VMBackupPolicyByTag/metadata.json")
  policy_rule = file("${path.module}/policydefinitions/VMBackupPolicyByTag/policy.json")
  parameters  = file("${path.module}/policydefinitions/VMBackupPolicyByTag/parameters.json")
}
