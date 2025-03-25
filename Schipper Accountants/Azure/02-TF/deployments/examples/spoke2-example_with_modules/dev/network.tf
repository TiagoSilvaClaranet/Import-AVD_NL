# Create a resource group for the network resources
module network_resource_group {
   source   = "./modules/tf-azurerm-resource-group"
   name     = [local.network_resource_group_name]
   location = var.location
   tags     = local.common_tags
 }

# Create the virtual networks for the spoke
module vnet {
  source                    = "./modules/tf-azurerm-vnet"
  location                  = var.location
  tags                      = local.common_tags
  vnets                     = var.vnets
  resource-group-name       = module.network_resource_group.resource_group_names[0]
  environment               = var.environment
  log-analytics-resource-id = var.log-analytics-resource-id
  #depends_on                = [module.network_resource_group]
}

# Create the subnets for the spoke
module subnet {
  source              = "./modules/tf-azurerm-subnet"
  location            = var.location
  resource-group-name = module.network_resource_group.resource_group_names[0]
  subnets             = var.subnets
  depends_on          = [module.vnet]
}

# Create the Network Security Groups for the spoke
module nsg {
  source              = "./modules/tf-azurerm-security-group"
  location            = var.location
  #resource-group-name = var.network-resource-group
  resource-group-name = module.network_resource_group.resource_group_names[0]
  nsgs                = var.nsgs
  tags                = local.common_tags
}

# Create the routing tables and routes for the spoke
module "route_table" {
  source = "./modules/tf-azurerm-route-table"
  location            = var.location
  tags                = local.common_tags
  resource-group-name = module.network_resource_group.resource_group_names[0]
  routes              = var.routes
  route_tables        = var.route_tables
}

# Associate the subnets with the routing tables and network security groups
module subnet_asoc {
  source          = "./modules/tf-azurerm-subnet-association"
  route_table_map = module.route_table.route_map
  nsg_map         = module.nsg.nsg_map
  subnet_map      = module.subnet.subnet_map
  subnet_udrs     = var.subnet_udrs
  subnet_nsgs     = var.subnet_nsgs
}










