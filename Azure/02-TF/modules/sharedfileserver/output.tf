output "sharedfileserver-local-password" {
  value     = random_password.sharedfileserver-local-password.result
  sensitive = true
}

output "sharedfileserver-name" {
  value     = azurerm_windows_virtual_machine.sharedfileserver.computer_name
}