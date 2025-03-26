<#
.SYNOPSIS
    Create a backup of the config and other files and cleans the Core directory so new core update can be placed
.DESCRIPTION
    Create a backup of the config and other files and cleans the Core directory so new core update can be placed
.NOTES
    v0.0.1 - 13-10-2023
    First quick and dirty version.
    New Core files needs to be placed manually from Worksmart365 template
.LINK
    -
.EXAMPLE
    Backup-CoreConfig.ps1
    Create a backup of the config and other files and cleans the Core directory so new core update can be placed
#>



# Create a timestamp for versioning
$timeStamp =  $(get-date -f MM-dd-yyyy_HH_mm_ss)

$backupdir = "./configbackup_$timeStamp"
$backupfiles = ".terraform.lock.hcl","backend.tf","provider.tf","settings.management_groups.tf","terraform.tfvars"

# Create a backup of the config files
# Create backup directory if not exist
if (!(Test-Path -Path $backupdir)) {
    New-Item -ItemType Directory -Path $backupdir
}
foreach ($file in $backupfiles) {
    Copy-Item -Path $file -Destination $backupdir
}


# Archive the old version files
$archivedir = "./backup_$timeStamp"

# Create archive directory if not exist
if (!(Test-Path -Path $archivedir)) {
    New-Item -ItemType Directory -Path $archivedir
}
Move-Item -Path "./policydefinitions" -Destination $archivedir
Get-ChildItem -Path "./" -File | Move-Item -Destination $archivedir

# Restore the backup of the config files
Get-ChildItem -Path $backupdir  -File | Copy-Item -Destination "./"


# Manually Copy the core directory from Worksmart365 template
Write-Output "For now manually Copy the core directory from Worksmart365 template"
#svn export --force https://claranetbenelux@dev.azure.com/claranetbenelux/Worksmart365/_git/Worksmart365-Azure//02-TF/deployments/core
