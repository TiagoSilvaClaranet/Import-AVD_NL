# Creates an Azure Key Vault
# Naming convention needs to be globally unique and between 3-24 characters
# The current user running the TF is added as a user (access policy) to the key vault

# Retrieve the current client context which we can use to retrieve the current user and tenant id
data "azurerm_client_config" "current" {}

data "azuread_user" "kvt-users" {
  count = length(var.keyvault_user_object_ids)
  object_id = var.keyvault_user_object_ids[count.index]
}

data "azuread_service_principal" "kvt-spns" {
  count = length(var.keyvault_service_principal_ids)
  object_id = var.keyvault_service_principal_ids[count.index]
}

# Create the Azure Key Vault
resource "azurerm_key_vault" "kv-shared" {
  #name                        = "kvzzz101sharedprodweu001"
  #name                        = "123456789012345678901234" # max 24 characters
  name                        = "kv${lower(substr(var.nlcnumber,3,6))}shared${var.environment}${var.location_short}${var.resourcesuffix}"
  location                    = azurerm_resource_group.rg-shared.location
  resource_group_name         = azurerm_resource_group.rg-shared.name
  enabled_for_disk_encryption = true


  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  
  sku_name = "standard"

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  /* Optionally limit network access
    network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    #ip_rules       = ["1.2.3.4/32"]
    # virtual_network_subnet_ids      =
  }
  */

  tags = merge(var.common_tags,
  {
    Environment  = var.environment
    Customer     = var.nlcnumber
    Owner        = "Cloud"
  })

}

# User access policies
resource "azurerm_key_vault_access_policy" "kv-shared-accesspolicy_users" {
  count = length(var.keyvault_user_object_ids)
  key_vault_id = azurerm_key_vault.kv-shared.id
  
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_user.kvt-users[count.index].object_id

  key_permissions = [
    "Get",
  ]
  secret_permissions = [
    "Get","Set","List", "Delete", "Purge"
  ]
  storage_permissions = [
    "Get",
  ]
}

# Service Principal access policies
resource "azurerm_key_vault_access_policy" "kv-shared-accesspolicy_spns" {
  count = length(var.keyvault_service_principal_ids)
  key_vault_id = azurerm_key_vault.kv-shared.id
  
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_service_principal.kvt-spns[count.index].object_id

  key_permissions = [
    "Get",
  ]
  secret_permissions = [
    "Get","Set","List", "Delete", "Purge"
  ]
  storage_permissions = [
    "Get",
  ]
}

output "kv-shared-name" {
  value = azurerm_key_vault.kv-shared.name
}

output "kv-shared-id" {
  value = azurerm_key_vault.kv-shared.id
}

output "kv-shared-url" {
  value = azurerm_key_vault.kv-shared.vault_uri
}
