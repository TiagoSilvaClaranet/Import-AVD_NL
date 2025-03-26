# v1.4.0 - 13-10-2023

Added

  * Added Powershell script to quickly backup core config and other files

# v1.3.2 - 29-09-2023

Fixed

  * Backwards compatibility issue in r-managementgroups.tf when 'parent_management_group_id' is not set in 'settings_managementgroups.tf'
  
# v1.3.1 - 25-09-2023

Fixed

* Fixed missing Log Analytics Workspace ID parameter for LinuxMonitorAgent policy
Added
* Support for 10x5 and 24x7 Windows and Linux logging

Updated

* README updated with more clear instructions and policy assignments
  
## v1.4.0 - 28-09-2023

Updated

* Updated policy structure to remove data block dependencies on assignments for non existing policies
* Updated APA_Deploy_AMA with required LogAnalytics parameter

## v1.3.0 - 25-09-2023

Added

* Option to integrate in an existing management group structure

## v1.2.0 - 29-08-2023

Updated

* Updated APA's for Windows and Linux monitoring

## v1.1.1 - 06-07-2023

Added

* Added version and Changelog info

## v1.1.0 - 04-07-2023

Added

* Added Default Windows DCR Azure Policy Assignment
* Added VMInsights DCR Azure Policy Assignment
* Added variables to set DCR resource ID's

## v1.0.0 - xx-xx-2023

Initial version
