$rootPath = 'C:\ClaranetStaging\Applications'

$applications = @('Office365','OneDrive','FSLogix')

if ($applications.Count -eq 0) { Exit 0 }

foreach ($application in $applications) {
    $applicationPath = (Join-Path -Path $rootPath -ChildPath $application)
    Set-Location -Path $applicationPath

    $installer = Get-ChildItem -Path $applicationPath | Where-Object { $_.Name -like 'Install-*.ps1' }

    . $installer.FullName
}