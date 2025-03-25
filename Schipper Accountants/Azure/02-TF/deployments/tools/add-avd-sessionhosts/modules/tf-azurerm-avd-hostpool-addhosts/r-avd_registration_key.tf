# We generate a new registration key each time we run because there is no Terraform data objecte yet to retrieve the hostpool properties so we cant retrieve the current registration key

resource "time_rotating" "avd_registration_token_time" {
  rotation_days = 1
}

# Generate a Session Host registration token based on a time_rotating timestamp
resource "azurerm_virtual_desktop_host_pool_registration_info" "avd_registration_token" {
  #hostpool_id     = azurerm_virtual_desktop_host_pool.avd-hostpool.id
  hostpool_id     = var.avd_host_pool_id
  expiration_date = time_rotating.avd_registration_token_time.rotation_rfc3339
}