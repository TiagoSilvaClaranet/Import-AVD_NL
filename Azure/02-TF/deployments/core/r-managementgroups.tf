# Getting Service Principal
data "azuread_service_principal" "ado_spn" {
  object_id = var.service_principal_id
}

resource "azurerm_management_group" "level_1" {
  for_each                    = local.level_1
  display_name                = each.value["display_name"]
  name                        = each.value["name"]
  parent_management_group_id  = try(each.value["parent_management_group_id"],null) # Will use root management group by default if omitted (null)
}

# Assign Reader permissions to level 1 management group
resource "azurerm_role_assignment" "imageManagementimg01" {
  for_each              = local.level_1
  scope                 = azurerm_management_group.level_1[each.key].id
  role_definition_name  = "Reader"
  principal_id          = data.azuread_service_principal.ado_spn.object_id
}

resource "azurerm_management_group" "level_2" {
  for_each                   = local.level_2
  display_name               = each.value["display_name"]
  name                       = each.value["name"]
  parent_management_group_id = azurerm_management_group.level_1[each.value["parent_management_group"]].id
  subscription_ids           = each.value["subscription_ids"]
  depends_on                 = [azurerm_management_group.level_1]
}

resource "azurerm_management_group" "level_3" {
  for_each                   = local.level_3
  display_name               = each.value["display_name"]
  name                       = each.value["name"]
  parent_management_group_id = azurerm_management_group.level_2[each.value["parent_management_group"]].id
  subscription_ids           = each.value["subscription_ids"]
  depends_on                 = [azurerm_management_group.level_2]
}

resource "azurerm_management_group" "level_4" {
  for_each                   = local.level_4
  display_name               = each.value["display_name"]
  name                       = each.value["name"]
  parent_management_group_id = azurerm_management_group.level_3[each.value["parent_management_group"]].id
  subscription_ids           = each.value["subscription_ids"]
  depends_on                 = [azurerm_management_group.level_3]
}

resource "azurerm_management_group" "level_5" {
  for_each                   = local.level_5
  display_name               = each.value["display_name"]
  name                       = each.value["name"]
  parent_management_group_id = azurerm_management_group.level_4[each.value["parent_management_group"]].id
  subscription_ids           = each.value["subscription_ids"]
  depends_on                 = [azurerm_management_group.level_4]
}

resource "azurerm_management_group" "level_6" {
  for_each                   = local.level_6
  display_name               = each.value["display_name"]
  name                       = each.value["name"]
  parent_management_group_id = azurerm_management_group.level_5[each.value["parent_management_group"]].id
  subscription_ids           = each.value["subscription_ids"]
  depends_on                 = [azurerm_management_group.level_5]
}