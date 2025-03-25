# Subnet Module

This module will a series of subnets and associate *n* subnets to a Virtual Network

The Module requires you to provide an existing resource Group, deployment location and a valid Log Analytics resource ID. The deployment will all be to a single resource group. 

Optionally you can provide the Module with the Resource ID of a DDOS plan to attach to this Virtual Network as well as a map of tags to apply to the virtual-networks. 

Provide the virtual networks and their associated subnets in the following format: 

```
subnets = [{
  vnet = "vn-core"
  subnets = [{
    "name"              = "GatewaySubnet"
    "cidr"              = "10.190.0.0/24"
    "nsg_name"          = "dmz01-test-nsg"
    "route_table_name"  = ""
    "service_endpoints" = ["Microsoft.KeyVault"]
    },
    {
      "name"              = "Management"
      "cidr"              = "10.190.0.0/26"
      "nsg_name"          = ""
      "route_table_name"    = "table_name"
      "service_endpoints" = []
    }
  ]
  },
  {
    vnet = "vn-prod"
    subnets = [{
      "name"              = "GatewaySubnet"
      "cidr"              = "10.190.0.0/28"
      "nsg_name"          = ""
      "route_table_name"    = ""
      "service_endpoints" = []
    }]
  }
]

```
**Note that there is a 1:1 relationship between virtual network and subnet. Each supplied virtual network must have at least 1 subnet**

To add, remove or edit additional subnets or virtual networks just edit the map variable. 

## Required Vars
| Variable | Type | Description|
|----------|------|------------|
| resource_group_name | string   | The name of the **existing** resource group to deploy these virtual networks in to|
| subnets |  |nested map of each subnet and its address space|
| location | string |Azure location for the deployment|


## Optional Vars
| Variable | Type | Description|
|----------|------|------------|
| tags| map(string) |A map of tags to apply to the resource. |
