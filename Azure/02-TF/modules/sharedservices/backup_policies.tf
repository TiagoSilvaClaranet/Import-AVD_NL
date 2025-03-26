
resource "azurerm_backup_policy_vm" "DailyBackup-30Days" {
  name                = "DailyBackup-30Days"
  resource_group_name = azurerm_resource_group.rg-shared.name
  recovery_vault_name = azurerm_recovery_services_vault.rsv-vault.name

  timezone = "W. Europe Standard Time"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 30
  }

/*
  retention_weekly {
    count    = 42
    weekdays = ["Sunday", "Wednesday", "Friday", "Saturday"]
  }

  retention_monthly {
    count    = 7
    weekdays = ["Sunday", "Wednesday"]
    weeks    = ["First", "Last"]
  }

  retention_yearly {
    count    = 77
    weekdays = ["Sunday"]
    weeks    = ["Last"]
    months   = ["January"]
  }
  */
}

resource "azurerm_backup_policy_vm" "DailyBackup-90Days" {
  name                = "DailyBackup-90Days"
  resource_group_name = azurerm_resource_group.rg-shared.name
  recovery_vault_name = azurerm_recovery_services_vault.rsv-vault.name

  timezone = "W. Europe Standard Time"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 90
  }

/*
  retention_weekly {
    count    = 42
    weekdays = ["Sunday", "Wednesday", "Friday", "Saturday"]
  }

  retention_monthly {
    count    = 7
    weekdays = ["Sunday", "Wednesday"]
    weeks    = ["First", "Last"]
  }

  retention_yearly {
    count    = 77
    weekdays = ["Sunday"]
    weeks    = ["Last"]
    months   = ["January"]
  }
  */
}

resource "azurerm_backup_policy_vm" "DailyBackup-7Days" {
  name                = "DailyBackup-7Days"
  resource_group_name = azurerm_resource_group.rg-shared.name
  recovery_vault_name = azurerm_recovery_services_vault.rsv-vault.name

  timezone = "W. Europe Standard Time"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 7 # 7 days is minimum
  }
}

resource "azurerm_backup_policy_vm" "DailyBackup-365Days" {
  name                = "DailyBackup-365Days"
  resource_group_name = azurerm_resource_group.rg-shared.name
  recovery_vault_name = azurerm_recovery_services_vault.rsv-vault.name

  timezone = "W. Europe Standard Time"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 365 # 7 days is minimum
  }
}


/*
resource "azurerm_backup_policy_file_share" "DailyBackupFileShare-30Days" {
  name                = "DailyBackupFileShare-30Days"
  resource_group_name = azurerm_resource_group.rg-shared.name
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

*/

####################################################################################################
# Azure SQL VM Back-up Policies                                                                    #
####################################################################################################

resource "azurerm_backup_policy_vm_workload" "DailyBackupSql-7Days" {
  name                = "DailyBackupSql-7Days"
  resource_group_name = azurerm_resource_group.rg-shared.name
  recovery_vault_name = azurerm_recovery_services_vault.rsv-vault.name

  workload_type = "SQLDataBase"

  settings {
    time_zone           = "W. Europe Standard Time"
    compression_enabled = false
  }

  protection_policy {
    policy_type = "Full"

    backup {
      frequency = "Daily"
      time      = "23:00"
    }

    retention_daily {
      count = 7
    }
  }

 protection_policy {
    policy_type = "Log"

    backup {
      frequency_in_minutes = 720
    }

    simple_retention {
      count = 7
    }
  }
}

resource "azurerm_backup_policy_vm_workload" "DailyBackupSql-30Days" {
  name                = "DailyBackupSql-30Days"
  resource_group_name = azurerm_resource_group.rg-shared.name
  recovery_vault_name = azurerm_recovery_services_vault.rsv-vault.name

  workload_type = "SQLDataBase"

  settings {
    time_zone           = "W. Europe Standard Time"
    compression_enabled = false
  }

  protection_policy {
    policy_type = "Full"

    backup {
      frequency = "Daily"
      time      = "23:00"
    }

    retention_daily {
      count = 30
    }
  }

 protection_policy {
    policy_type = "Log"

    backup {
      frequency_in_minutes = 720
    }

    simple_retention {
      count = 7
    }
  }
}

resource "azurerm_backup_policy_vm_workload" "DailyBackupSql-90Days" {
  name                = "DailyBackupSql-90Days"
  resource_group_name = azurerm_resource_group.rg-shared.name
  recovery_vault_name = azurerm_recovery_services_vault.rsv-vault.name

  workload_type = "SQLDataBase"

  settings {
    time_zone           = "W. Europe Standard Time"
    compression_enabled = false
  }

  protection_policy {
    policy_type = "Full"

    backup {
      frequency = "Daily"
      time      = "23:00"
    }

    retention_daily {
      count = 90
    }
  }

 protection_policy {
    policy_type = "Log"

    backup {
      frequency_in_minutes = 720
    }

    simple_retention {
      count = 7
    }
  }
}

resource "azurerm_backup_policy_vm_workload" "DailyBackupSql-365Days" {
  name                = "DailyBackupSql-365Days"
  resource_group_name = azurerm_resource_group.rg-shared.name
  recovery_vault_name = azurerm_recovery_services_vault.rsv-vault.name

  workload_type = "SQLDataBase"

  settings {
    time_zone           = "W. Europe Standard Time"
    compression_enabled = false
  }

  protection_policy {
    policy_type = "Full"

    backup {
      frequency = "Daily"
      time      = "23:00"
    }

    retention_daily {
      count = 365
    }
  }

 protection_policy {
    policy_type = "Log"

    backup {
      frequency_in_minutes = 720
    }

    simple_retention {
      count = 7
    }
  }
}



