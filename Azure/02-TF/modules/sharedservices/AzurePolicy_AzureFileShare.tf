resource "azurerm_backup_policy_file_share" "azurepolicy_azurefilesharebackupdaily-7days" {
  name                = "AzureFileshare-DailyBackup-7Days"
  resource_group_name = azurerm_recovery_services_vault.rsv-vault.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.rsv-vault.name

  timezone = "W. Europe Standard Time"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 7
  }
}

resource "azurerm_backup_policy_file_share" "azurepolicy_azurefilesharebackupdaily-30days" {
  name                = "AzureFileshare-DailyBackup-30Days"
  resource_group_name = azurerm_recovery_services_vault.rsv-vault.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.rsv-vault.name

  timezone = "W. Europe Standard Time"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 30
  }
}

resource "azurerm_backup_policy_file_share" "azurepolicy_azurefilesharebackupdaily-90days" {
  name                = "AzureFileshare-DailyBackup-90Days"
  resource_group_name = azurerm_recovery_services_vault.rsv-vault.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.rsv-vault.name

  timezone = "W. Europe Standard Time"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 90
  }
}