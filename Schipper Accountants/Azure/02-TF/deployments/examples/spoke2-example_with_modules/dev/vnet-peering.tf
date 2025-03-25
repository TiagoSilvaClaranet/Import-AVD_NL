variable peerings {}

# Create vnet-peering from spoke to hub
module vnet_peering {
  source              = "./modules/tf-azurerm-vnet-peering"
  resource-group-name = local.network_resource_group_name
  virtual-network     = module.vnet.vnet-names[0]
  #virtual-network     = "vnet-spoke1_example-dev-weu-003"
  peerings            = var.peerings
}

# We still do need to cvreate vnet-peering from hub to spoke!!!



/*
#####
# Use the Claranet module to set up the peering
# This sets up a bi-directonal peering between the spoke and the hub
module "azure-vnet-peering" {
  source  = "claranet/vnet-peering/azurerm"
  version = "5.0.1"

  providers = {
    azurerm.src = azurerm
    azurerm.dst = azurerm
  }

  vnet_src_id  = module.vnet.vnet-ids[0]
  vnet_dest_id = data.terraform_remote_state.hubstate.outputs.hub_vnet_id

  allow_forwarded_src_traffic  = true
  allow_forwarded_dest_traffic = false

  allow_virtual_src_network_access  = true
  allow_virtual_dest_network_access = true
}
*/