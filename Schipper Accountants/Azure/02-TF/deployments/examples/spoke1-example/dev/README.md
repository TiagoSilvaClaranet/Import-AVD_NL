# Spokes

Each spoke needs an own vnet and subnets. This vnet needs to be paired with the HUB's vnet using vnet peering.
This vnet peering is configured by vnet-peering.tf

This spoke is deployed using plain Terraform without the use of modules


# Example Spoke configuration #1
This example Landing Zone deploys the following resources:
- Resource Group (Network)
- Virtual Network
- Subnets (GatewaySubnet, snet-subnet1)
- TODO - Network Security Groups
- TODO - Assign NSG to subnets
- Virtual Network Peering with the HUB vnet
- TODO - Route table with default route to HUB's gateway
- TODO - Assign route table to all subnets 
