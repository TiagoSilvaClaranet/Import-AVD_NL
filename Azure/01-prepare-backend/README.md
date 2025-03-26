This module creates an Azure Storage Account to be used as Terraform backend

# Instructions
- Rename/Copy terraform.tfvars-example to terraform.tfvars
- Change the nlcnumber to the correct NLC number of the customer
- Optionally change the location and resourcesuffix (default is 001)
- terraform init
- terraform apply

The backend storage account will be created now