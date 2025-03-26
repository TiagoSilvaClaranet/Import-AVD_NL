# Schipper Spoke Application Landing Zone

Each spoke needs an own vnet and subnets. This vnet needs to be paired with the HUB's vnet using vnet peering.
This vnet peering is configured by vnet-peering.tf

For simplicity and undertandability this spoke is deployed using plain Terraform without the use of modules (so no DRY code). 


# Deployed Resources
This Landing Zone deploys the following resources:
- Resource Group (Network)
- Virtual Network
- Subnets 
- Virtual Network Peering with the HUB vnet
- Network Security Groups
- Assign NSG to subnets
- Route table with default route to HUB's gateway
- Assign route table to all subnets 