output "vnet-names" {
    value = values(azurerm_virtual_network.virtual_network)[*].name
}

output "vnet-ids" {
        value = values(azurerm_virtual_network.virtual_network)[*].id
}
