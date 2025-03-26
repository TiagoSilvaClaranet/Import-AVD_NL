# Define Terraform provider
terraform {
  required_version = ">= 1.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.34.0"
    }
  }
}

# Configure the Azure Provider
provider "azurerm" {
  subscription_id = "63cf28ad-7dcb-431b-a539-58a6e358db3d"
  features {}
}