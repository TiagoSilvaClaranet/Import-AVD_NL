resource "azurerm_resource_group" "azurerm-resource-group" {
    for_each            = toset(var.name)

    name                = each.value
    location            = var.location
    tags                = var.tags

    lifecycle {
        ignore_changes  = [ tags["creation_timestamp"] ]
    }
}
