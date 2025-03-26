# Define Terraform provider
terraform {
  required_version = ">= 1.2.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.15.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-tfstate-weu-001"
    storage_account_name = "nlc000883sttfstateweu001"
    container_name       = "terraform-state"
    key                  = "terraform-spoke-schipper.tfstate"
    #access_key           = "xxxxx" # Please use environment variable ARM_ACCESS_KEY instead or retreive from Keyvault
  }
}

# Configure the Azure Provider
provider "azurerm" {
  subscription_id = "63cf28ad-7dcb-431b-a539-58a6e358db3d"
  features {}
}