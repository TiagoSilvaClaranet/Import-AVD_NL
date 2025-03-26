resource "azurerm_virtual_desktop_host_pool" "avd-hostpool" {
  location            = var.location
  resource_group_name = var.resource_group

  name                     = var.name
  friendly_name            = var.friendly_name
  validate_environment     = var.validate_environment
  start_vm_on_connect      = var.start_vm_on_connect
  custom_rdp_properties    = var.custom_rdp_properties
  description              = var.description
  type                     = var.type
  maximum_sessions_allowed = var.maximum_sessions_allowed
  load_balancer_type       = var.load_balancer_type #[Breadthfirst, DepthFirst]
  /*scheduled_agent_updates {
    enabled = true
    schedule {
      day_of_week = "Saturday"
      hour_of_day = 2
    }
    use_session_host_timezone = true
  }
  */
  

  tags = merge(var.common_tags,
    {
      Customer = var.nlcnumber
      Owner    = var.owner
      Hostpool_name_short = var.hostpool_name_short
  })

    lifecycle {
    ignore_changes = [load_balancer_type]
  }
}
/*
# Create a rotated timestamp which is automatically renewed after 'rotation_days' count
resource "time_rotating" "avd_registration_token_time" {
  rotation_days = 30
}

# Generate a Session Host registration token based on a time_rotating timestamp
resource "azurerm_virtual_desktop_host_pool_registration_info" "avd_registration_token" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.avd-hostpool.id
  expiration_date = time_rotating.avd_registration_token_time.rotation_rfc3339
}
*/
