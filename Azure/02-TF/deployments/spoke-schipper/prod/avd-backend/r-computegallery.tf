# generate a random string (consisting of four characters)
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
resource "random_string" "random" {
  length  = 4
  upper   = false
  special = false
}

# Create the Azure Computer Gallery (Shared Image Gallery)
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image_gallery
resource "azurerm_shared_image_gallery" "sig" {
  #name                = "sig_avd_${random_string.random.id}"
  name                = "sigavd${var.sig_name}${var.environment}${var.location_short}${random_string.random.id}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  description         = "Shared images"

  tags = merge(var.common_tags,
    {
     # Customer = var.nlcnumber
     # Owner    = var.owner
  })
}

# Creates image definition
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image
/*
resource "azurerm_shared_image" "avd_image" {
  name                = "avd-image"
  gallery_name        = azurerm_shared_image_gallery.sig.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Windows"
  hyper_v_generation  = "V2"
  

  identifier {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-11"
    sku       = "win11-22h2-avd"
  }

    tags = merge(var.common_tags,
    {
      Customer = var.nlcnumber
     # Owner    = var.owner
  })
}
*/