# Spokes

Each spoke needs an own vnet and subnets. This vnet needs to be paired with the HUB's vnet using vnet peering.
This vnet peering is configured by vnet-peering.tf


# Example Spoke configuration #2
This example Landing Zone deploys the following resources:
- Resource Group (Network)
- Virtual Network
- Subnets (GatewaySubnet, snet-subnet1)
- Network Security Groups
- Assign NSG to subnets
- Virtual Network Peering with the HUB vnet
- Route table with default route to HUB's gateway
- Assign route table to all subnets 
