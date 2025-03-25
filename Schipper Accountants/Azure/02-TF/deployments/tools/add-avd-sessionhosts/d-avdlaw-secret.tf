# Get properties of the key vault

# TODO
# - Replace static keyvault name and resource group by a dynamic lookup using remote state
# - Add a dedicated keyvault for AVD

data "azurerm_key_vault" "avd-keyvault" {

  name                = var.shared_keyvault_name  # Name of the Customers Shared Keyvault
  resource_group_name = var.shared_keyvault_rg    # Resource Group which contains the keyvault
}

# Get the secret

data "azurerm_key_vault_secret" "avdlaw-secret" {

  name         = "AVDLAW-${var.log_analytics_workspace_id}"
  key_vault_id = data.azurerm_key_vault.avd-keyvault.id

}