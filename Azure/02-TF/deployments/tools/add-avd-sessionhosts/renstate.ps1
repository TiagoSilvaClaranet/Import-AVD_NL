$prefix = Get-Date -Format yyMMddhhmmss

$path = "terraform.tfstate"
if (Test-Path -Path $path) {
    Rename-Item -Path $path -NewName "$($prefix)_terraform.tfstate"
}
$path = "terraform.tfstate.backup"
if (Test-Path -Path $path) {
    Rename-Item -Path $path -NewName "$($prefix)_terraform.tfstate.backup"
}