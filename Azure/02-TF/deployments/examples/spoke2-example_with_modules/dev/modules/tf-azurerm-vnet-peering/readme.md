# VNET Module

This module will create peerings for Virtual Networks

The Module requires you to provide an existing Resource Group and Vnet. The deployment will all be to a single resource group. 

Provide the peerings and their associated settings in the following format: 

```
peerings = {
  vn-core = {
    prod = {
      "remote-virtual-network-id"    = ""
      "allow-virtual-network-access" = true
      "allow-forwarded-traffic"      = true
      "allow-gateway-transit"        = true
      "use-remote-gateways"          = false
    }
  }
}
```
To add, remove or edit a peering just edit the map variable. 

## Required Vars
| Variable | Type | Description|
|----------|------|------------|
| resource_group_name | string   | The name of the **existing** resource group to deploy these virtual networks in to|
| peerings | map(map(map(string))) | a map of a map of a map of the peering settings|
| virtual-network | string | the name of the vnet making the peering

