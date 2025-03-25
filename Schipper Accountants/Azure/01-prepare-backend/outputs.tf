output "tfstate-name" {
    value = azurerm_storage_account.sttfstate.name
}

output "tfstate-containername" {
    value = azurerm_storage_container.sttfstatecontainer.name
}

output "tfstate-key" {
    value     = azurerm_storage_account.sttfstate.primary_access_key
    sensitive = true
}

output "tfstate-url" {
    value = azurerm_storage_container.sttfstatecontainer.id
}