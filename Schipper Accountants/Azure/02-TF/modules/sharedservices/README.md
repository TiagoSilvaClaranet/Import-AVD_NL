[[_TOC_]]
# Main Resources
- Create Resource Group for all Shared Resources
- Create a log analytics workspace
- Create a Diagnostics Storage Account
- Create a Recovery Services Vault (LRS)
- Create a Key Vault
- Create an Automation Account
- Link automation account to log analytics workspace
- (optionally) enables update management solution
- (optionally) enables change tracking solution
- Create a VM backup policy with 90 days retention
- Create a VM backup policy with 30 days retention
- Create a VM backup policy with 7 days retention
- Create a SQL VM backup policy with 365 days retention
- Create a SQL VM backup policy with 90 days retention
- Create a SQL VM backup policy with 30 days retention
- Create a SQL VM backup policy with 7 days retention
- Create a Data Collection Rule with default metrics and logs for Windows VM's

# Keyvault
## The service principal used must have the following permissions
- Reader permissions on all management groups
- Directory Readers permissions to lookup users from Azure AD

# Azure Policies
- Create an Azure Policy to enforce VM backups based on BackupPolicy tag (BackupDaily-90Days)
- Create an Azure Policy to enforce VM backups based on BackupPolicy tag (BackupDaily-30Days)
- Create an Azure Policy to enforce VM backups based on BackupPolicy tag (BackupDaily-7Days)

- Create an Azure Policy to install Microsoft Monitoring Agent on VM's
- Create an Azure Policy to install Dependency Agent on VM's
- Create an Azure Policy to install Log Analytics Agent on VM's

- Create an Azure Policy to assign the default Windows VM DCR to all Windows VM's in the subscription

# Update Schedules
- Create Daily update schedule
- Create Weekly 1 update schedule based on UpdateGroup Tag (UpdateGroup:1)
- Create Weekly 2 update schedule based on UpdateGroup Tag (UpdateGroup:2)
- Create Daily Definition Update Schedule

# Notes
- Location is currently hardcoded West Europe (weu)