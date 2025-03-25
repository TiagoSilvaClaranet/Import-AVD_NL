# Deploys one or more AVD session hosts to an existing AVD host pool

See CHANGELOG.md for the Changelog

## Prerequisites
- Host pool to deploy the Session Hosts in
- Subnet to deploy the Session Hosts in
- Image in an Azure Compute Gallery (former Shared Image Gallery)
- Log Analytics Workspace

## Instructions
- Create xxx.tfvars in which you set the variables. (Copy sample.tfvars_example to xxx.tfvars)
- Add vmjoiner password to keyvault (name = vmjoiner)
- Add AVD Log Analytics Workspace key to the keyvault (name = AVDLAW-[Log Analytics Workspace ID])


## Notes
It retrieves the vmjoiner password from  the Hub's keyvault (d-vmjoiner_secret.tf) so add this secret if not already done
It retrieves the AVD Log Analytics Workspace Key from the Hub's keyvault (d-avdlaw_secret.tf) 

Use the following variables to set the number of hosts and starting number to deploy
avd_host_pool_size              = 1
avd_starting_offset             = 1

The module deploys sessions hosts and creates state files.
When you want to deploy session hosts in other host pools you need to rename the state file first (for the time being)
You can use renstate.ps1 for this

The Azure Monitoring Agent is installed while deploying and the DCR rule provided is attached

## TODO

