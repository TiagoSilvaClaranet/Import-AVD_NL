# Create Storage Account and Container for Terraform State files
/*
# Generate a random storage name
resource "random_string" "tf-namernd" {
  length  = 3
  upper   = false
  numeric = true
  lower   = true
  special = false
}
*/

resource "azurerm_resource_group" "rg-tfstate" {
   name         = "rg-tfstate-${var.location_short}-${var.resourcesuffix}"
   location     = var.location
   lifecycle {
     prevent_destroy = true
   }
}

resource "azurerm_storage_account" "sttfstate" {
   name                       = "${lower(var.nlcnumber)}sttfstate${var.location_short}${lower(var.resourcesuffix)}"
   #name                       = "${lower(var.nlcnumber)}sttfstate${var.location_short}${random_string.tf-namernd.result}"
   resource_group_name        = azurerm_resource_group.rg-tfstate.name
   location                   = azurerm_resource_group.rg-tfstate.location
   account_tier               = "Standard"
   account_replication_type   = "ZRS"
   enable_https_traffic_only = true
   lifecycle {
     prevent_destroy = true
   }
}

resource "azurerm_storage_container" "sttfstatecontainer" {
   name                     = "terraform-state"
   storage_account_name     = azurerm_storage_account.sttfstate.name
   container_access_type    = "private"
}

