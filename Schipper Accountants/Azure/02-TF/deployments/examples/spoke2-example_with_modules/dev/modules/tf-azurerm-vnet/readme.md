# VNET Module

This module will a series of Virtual Networks

The Module requires you to provide an existing resource Group, deployment location and a valid Log Analytics resource ID. The deployment will all be to a single resource group. 

Optionally you can provide the Module with the Resource ID of a DDOS plan to attach to this Virtual Network as well as a map of tags to apply to the virtual-networks. 

Provide the virtual networks and their associated subnets in the following format: 

```
vnets = [{
  name    = "vn-core"
  cidr    = ["10.190.0.0/16"]
  dns     = []
  ddos_id = ""
  },
  {
    name    = "vn-prod"
    cidr    = ["10.189.0.0/16"]
    dns     = []
    ddos_id = ""
}]

```
To add, remove or edit virtual networks just edit the map variable. 

## Required Vars
| Variable | Type | Description|
|----------|------|------------|
| resource_group_name | string   | The name of the **existing** resource group to deploy these virtual networks in to|
| vnets| map(string) |a map of the virtual networks and their address spaces|
| location | string |Azure location for the deployment|
| log_analytics_workspace_id | string | full resource ID for logAnalytics. This will configure diagnostics for the virtual networks |


## Optional Vars
| Variable | Type | Description|
|----------|------|------------|
| tags| map(string) |A map of tags to apply to the resource. |
| ddos_protection_plan_id| string|The full resource ID of the DDOS protection Plan to apply to the virtual networks|
| diagnostics_retention_policy| bool |Default: false. Override with true to enable Diagnostic retention|
| metrics_retention_policy | bool|Default: false.  Override with true to enable Metric retention|
