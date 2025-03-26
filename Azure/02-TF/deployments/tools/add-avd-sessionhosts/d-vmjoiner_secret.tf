# Get properties of the key vault
data "azurerm_key_vault" "keyvault" {
  name                = var.shared_keyvault_name  # Name of the Customers Shared Keyvault
  resource_group_name = var.shared_keyvault_rg    # Resource Group which contains the keyvault
}

# Get the secret
data "azurerm_key_vault_secret" "vmjoiner" {
  name         = "vmjoiner"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}
