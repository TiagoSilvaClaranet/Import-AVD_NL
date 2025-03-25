# Create AVD DAG
resource "azurerm_virtual_desktop_application_group" "dag" {
  resource_group_name          = var.resource_group
  host_pool_id                 = var.host_pool_id
  location                     = var.location
  type                         = var.type
  name                         = var.name
  friendly_name                = var.friendly_name
  description                  = var.description
  default_desktop_display_name = var.type == "Desktop" ? var.default_desktop_display_name : null

  tags = merge(var.common_tags,
    {
      Customer = var.nlcnumber
      Owner    = var.owner
  })
}
