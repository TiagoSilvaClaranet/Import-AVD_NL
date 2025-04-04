# Define Terraform provider
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-weu-001"         # Resource Group that contains the storage account for the Terraform state files
    storage_account_name = "nlc000883sttfstateweu001"   # Name of the Storage Account
    container_name       = "terraform-state"            # Container that contains the Terraform state files
    key                  = "terraform-core.tfstate"     # Name of the state file to use for this deployment
    
    #access_key           = "xxxxx"                     # Not Used! Please use environment variable ARM_ACCESS_KEY instead or retreive from Keyvault
  }
}
