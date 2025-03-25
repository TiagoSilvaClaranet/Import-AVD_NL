# This example Custom HUB Extension is used to deploy a resource group

resource "azurerm_resource_group" "MyResource" {
   name = "example-name"
   location = "West Europe"
}