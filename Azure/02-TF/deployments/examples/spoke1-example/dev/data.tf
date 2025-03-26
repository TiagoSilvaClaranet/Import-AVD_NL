locals {
  remote_state_file = "terraform-dev.tfstate"
}

data "terraform_remote_state" "hubstate" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-tfstate-weu-001"
    storage_account_name = "nlczzz101sttfstateweu001"
    container_name       = "terraform-state"
    key                  = local.remote_state_file
    #access_key           = "xxxxx" # Please use environment variable ARM_ACCESS_KEY instead or retreive from Keyvault
  }
}