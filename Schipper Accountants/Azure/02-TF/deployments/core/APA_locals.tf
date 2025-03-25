locals {
  # Get Resource ID of management groups to assign the policy to
  platform_and_lz_management_group_ids = {
                           platform = azurerm_management_group.level_2["platform"].id,
                           landing-zones = azurerm_management_group.level_2["landing-zones"].id
                          }
                          
  platform_management_group_ids = {
                           platform = azurerm_management_group.level_2["platform"].id
                          }

  lz_management_group_ids = {
                           landing-zones = azurerm_management_group.level_2["landing-zones"].id
                          }

}