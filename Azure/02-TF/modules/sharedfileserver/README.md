# Description
This module deploys a single Shared Fileserver in a Worksmart365 HUB environment with a single data disk and will join to a domain with credentials are supplied

# Usage
````
module "sharedfileserver" {
  source         = "../../../modules/sharedfileserver"
  resource_group = var.fileserver_resource_group

  location   = var.location
  nlcnumber  = var.nlcnumber
  servername = var.fileserver_servername # Default is 'FS01'       

  environment        = var.fileserver_environment
  fileserver_ip      = var.fileserver_ip
  data_disk1_size    = var.fileserver_data_disk1_size
  fileserver_skusize = var.fileserver_skusize   # Default is 'Standard_B2ms'
  image_sku          = var.fileserver_image_sku # Default is '2019-Datacenter'

  join_adds_username  = "<Domain Join Account username>"
  join_adds_password  = "<Domain Join Account password>"
}
````

# Outputs
- sharedfileserver-local-password
- sharedfileserver-name


# Known issues
- When you want to destroy the resources while the Virtual Machine is not running you get:
````
 Error: compute.VirtualMachineExtensionsClient#Delete: Failure sending request: StatusCode=0 -- Original Error: autorest/azure: Service returned an error. Status=<nil> Code="OperationNotAllowed" Message="Cannot modify extensions in the VM when the VM is not running."
 ````
 You have to start the Virtual Machine or manually remove the extention from terraform state