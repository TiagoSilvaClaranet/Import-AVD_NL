[cmdletBinding()]
Param (
    [Parameter(Mandatory=$false, Position=0, HelpMessage="Invoke-AzVmRunCommand requires the -Parameter property, therefor this dummy parameter for scripts that don't need one")]
    $Dummy
)

### Removing C:\ClaranetStaging ###
if (Test-Path -Path 'C:\ClaranetStaging' -PathType Container) {
    Write-Output "Removing 'C:\ClaranetStaging'"
    Remove-Item -Path 'C:\ClaranetStaging' -Recurse -Force
}

### Add other customizations below ###