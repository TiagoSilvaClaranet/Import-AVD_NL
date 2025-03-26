
#####################################
# Create Recovery Services Vault
#####################################
resource "azurerm_recovery_services_vault" "rsv-vault" {
  name                = "rsv-shared-prod-weu-${var.resourcesuffix}"
  location            = azurerm_resource_group.rg-shared.location
  resource_group_name = azurerm_resource_group.rg-shared.name
  sku                 = "Standard"
  #sku                 = "RS0"
  soft_delete_enabled = true
  storage_mode_type   = var.recoveryservicesvault_storage_mode

  tags = merge(var.common_tags,
    {
      Environment  = var.environment
      Customer     = var.nlcnumber
      Owner        = "Cloud"
    })
}

# This resource still uses to old format with the 'log' monitor diagnostic setting
# As of AzureRM 3.40 module this is replaced by 'enabled_log'
# From AzureRM 4.0 the old 'log' setting will be removed completely
# The new enabled_log setting will fix the issue where you needed to specify all posible log settings even if it's disabled
# Ommiting a single entry will cause terraform to redploy all settings in every apply.
resource "azurerm_monitor_diagnostic_setting" "rsv-diagnostics" {
  name                        = "rsv-diagnostics"
  target_resource_id          = azurerm_recovery_services_vault.rsv-vault.id
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.log-shared.id
  log_analytics_destination_type = "Dedicated"

    log {
    category = "CoreAzureBackup"
    enabled = "true"

    retention_policy {
      enabled = false
    }
  }
    log {
    category = "AddonAzureBackupJobs"
    enabled = "true"

    retention_policy {
      enabled = false
    }
  }
    log {
    category = "AddonAzureBackupAlerts"
    enabled = "true"

    retention_policy {
      enabled = false
    }
  }
    log {
    category = "AddonAzureBackupPolicy"
    enabled = "true"

    retention_policy {
      enabled = false
    }
  }

    log {
    category = "AddonAzureBackupStorage"
    enabled = "true"

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "AddonAzureBackupProtectedInstance"
    enabled = "true"

    retention_policy {
      enabled = false
    }
  }
  metric {
    category = "Health"
    enabled = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "AzureBackupReport"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AzureSiteRecoveryEvents"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AzureSiteRecoveryJobs"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AzureSiteRecoveryProtectedDiskDataChurn"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AzureSiteRecoveryRecoveryPoints"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AzureSiteRecoveryReplicatedItems"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AzureSiteRecoveryReplicationDataUploadRate"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AzureSiteRecoveryReplicationStats"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }
}

