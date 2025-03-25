```
routes = [{
    table = "table name"
    disable_bgp_route = false
    route = [
        {
            name = ""
            address = ""
            hop_type = ""
            hop_ip = ""
        }
    ]
}]
```

Elements of route support:

    name - (Required) The name of the route.

    address_prefix - (Required) The destination CIDR to which the route applies, such as 10.1.0.0/16

    next_hop_type - (Required) The type of Azure hop the packet should be sent to. Possible values are VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None.

    next_hop_in_ip_address - (Optional) Contains the IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance.
