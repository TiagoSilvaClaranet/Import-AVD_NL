# Core
This module deploys the core resources


## Components
 - Management Groups
 - Management Groups subscription associations
 - Azure Policies Definitions
 - Azure Policy Assignments
    - Deploy Azure Monitoring Agent
    - Deploy Dependancy Agent in AMA mode
    - Assign DCR for VMInsights
    - Assign VM Backup Policy by Tag
    - Assign DCR for Windows VM counters
    - Assign DCR for Linux VM counters
    - Assign DCR for Windows Logs
    - Assign DCR for Linux Logs
 - RBAC (Not yet implemented!)

 ## Notes
For the automation (Pipelines) to work we need to create a Service Principal
### Aanmaken Service Principal
```
$SubID = xxxx # Replace with Subscription ID
az ad sp create-for-rbac --role="Owner" --scopes=/subscriptions/$SubID --name="sp-cbx-tf-ado"
```
**Zet de gegevens in RDM en Eventguard!**


Indien de gemaakt spn owner rechten moet hebben op meerdere subscriptions
```
az ad sp list --display-name sp-cbx-tf-ado
az role assignment create --assignee [AppId] --role "Owner" --scope /subscriptions/$SubId
```
### Toevoegen Service Connection in ADO
Voeg deze spn toe als Service Connection in het ADO project
```
Project Settings -> Service Connection -> Create Service Connection
   Azure Resource Manager
   Service Principal (manual) 
```
Geef de service connection de naam 'sp-cbx-tf-ado' (deze naam wordt gebruikt in automation)


 ## Usage (Create a copy of the example files)
 - Set terraform state backend configuration in backend.tf 
 - Set subscription id of root subscription in provider.tf 
 - Set customer_name in terraform.tfvars 
 - Set short_customer_name in terraform.tfvars (this will be used in the id's of the management groups)
 - Set service_principal_id in terraform.tfvars (this is the object id of the service prinicpal used for the ADO deployments)
 - Define all needed management groups and subscriptions in settings.management_groups.tf
 - Apply core

 ### After platform LZ deployment 
 - Set the DCR resource ID's in terraform.tfvars (platform lz needs to deployed first to create the DCR's!)
 - Reapply core