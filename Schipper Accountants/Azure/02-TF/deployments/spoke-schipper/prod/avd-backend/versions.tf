# Define Terraform provider
terraform {
  required_version = ">= 0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.15.0"
    }
  }
}

# Configure the Azure Provider
provider "azurerm" {

  features {}
}