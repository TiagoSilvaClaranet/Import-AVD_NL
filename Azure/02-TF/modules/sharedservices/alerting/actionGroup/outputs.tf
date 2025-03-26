output "mailActionGroupResourceId" {
    value = azurerm_monitor_action_group.mailActionGroup.id
    sensitive = true
}

output "pagerDutyActionGroupResourceId" {
    value = azurerm_monitor_action_group.pagerDutyActionGroup.id
    sensitive = true
}
