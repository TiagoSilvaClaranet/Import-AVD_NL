# Define Terraform provider
terraform {
  required_version = ">= 0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.34.0"
    }
    azapi = {
      source = "Azure/azapi"
      version = "= 1.1.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "2.39.0"
    }
  }
}

    