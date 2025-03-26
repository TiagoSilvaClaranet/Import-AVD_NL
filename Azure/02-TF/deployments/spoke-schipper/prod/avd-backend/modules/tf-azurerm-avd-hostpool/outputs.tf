output "host_pool_id" {
  value = azurerm_virtual_desktop_host_pool.avd-hostpool.id
}

#output "avd_hostpool_registration_token" {
#  value = azurerm_virtual_desktop_host_pool_registration_info.avd_registration_token.token
#  sensitive = true
#}

output "avd_host_pool_name" {
  value = azurerm_virtual_desktop_host_pool.avd-hostpool.name
}