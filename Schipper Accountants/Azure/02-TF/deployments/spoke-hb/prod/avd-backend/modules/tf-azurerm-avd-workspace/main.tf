#Create WVD workspace
resource "azurerm_virtual_desktop_workspace" "ws" {
  name                = var.name
  resource_group_name = var.resource_group
  location            = var.location
  friendly_name       = var.friendly_name
  description         = var.description

  tags = merge(var.common_tags,
  {
    Customer     = var.nlcnumber
    Owner        = var.owner
  })
}
