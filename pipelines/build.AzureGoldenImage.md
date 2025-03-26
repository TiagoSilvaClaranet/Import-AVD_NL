# Readme for deploy.newSessionHosts pipeline

[[_TOC_]]

## Requirements

### Storagr account

A storage account must be present with the following configuration. This is used to process applications during the Azure Image Builder process.

#### Blob: applications

A blob container with the name 'applications' should exist. The pipeline will automatically upload the Install-Phase*Applications.ps1 scripts to this container.

#### Share: staging

A file share with the name 'staging' should exist and on this file share a folder named 'Applications' should be created that hosts all applications that will be installed during the Azure Image Builder process. Applications should have there own folder with a version sub-folder that contains atleast a setup file like a msi or exe and a PowerShell installer script that starts with 'Install-'. See example below for folder structure.

staging
- Applications
  - 7-zip
    - 22.01
      - 7-zip_22.01.msi
      - Install-Application.ps1

**IMPORTANT: Do not store many versions of an application! Create an 'Archive' folder on the 'staging' share to keep older versions of an application**

### Customer Project Repo

1. Copy folder 'aib' from configurations from WorkSmart365-Azure repo to customer repo
2. Fill in aibPrereqs.tfvars with required information
3. Fill in parameters.imagebuilder.json with required information
4. Add applications with version to Install-Phase*Applications.ps1 $applications array. See example below

#### Install-Phase1Applications.ps1 example

```Powershell
$rootPath = 'C:\ClaranetStaging\Applications'

$applications = @('7-zip\22.01', 'Adobe.Reader\23.003.20201')

if ($applications.Count -eq 0) { Exit 0 }

foreach ($application in $applications) {
    $applicationPath = (Join-Path -Path $rootPath -ChildPath $application)
    Set-Location -Path $applicationPath

    $installer = Get-ChildItem -Path $applicationPath | Where-Object { $_.Name -like 'Install-*.ps1' }

    . $installer.FullName
}
```

## Customer Project Azure DevOps

If the 'GVG_MANUAL_INFRA_AS_CODE_01' variable group doesn't exist yet follow the steps below

1. In Azure DevOps in the customer project go to 'Pipelines -> Libray'
2. Click on '+ Variable group'
3. At 'Variable group name' fill in 'GVG_MANUAL_INFRA_AS_CODE_01'
4. On the top click on 'Security'
5. Click on 'Add' and fill in the following:
   - User or group: \<projectName> Build Service (claranetbenelux)
   - Role: Administrator
6.  When done click on 'Add'
7.  Click on 'Add' and fill in the following:
   - User or group: Project Collection Build Service (claranetbenelux)
   - Role: Administrator
8.  When done click on 'Add'
9.  On the top click on de 'save icon' (floppy disk)

1. Add following variables to variable group 'GVG_MANUAL_INFRA_AS_CODE_01' and add a number value for how many session hosts you want to deploy for that environment
    - StorageAccountResourceId
      - The resource id of the storage account that is described in the [Requirements](#requirements)
2. Create new pipeline from GIT repo using an existing pipeline
3. Select pipelines\build.azureGoldenImage.yaml
4. Rename pipeline to build.azureGoldenImage

If the 'GVG_DYNAMIC_INFRA_AS_CODE_01' variable group doesn't exist yet follow the steps below

1. In Azure DevOps in the customer project go to 'Pipelines -> Libray'
2. Click on '+ Variable group'
3. At 'Variable group name' fill in 'GVG_DYNAMIC_INFRA_AS_CODE_01'
4. Below 'Variables' click on '+ Add'
5. At 'Name' fill in 'Dummy'
6. At 'Value' fill in 'Variable'
7. On the top click on 'Save'
8. On the top click on 'Security'
9. Click on 'Add' and fill in the following:
   - User or group: \<projectName> Build Service (claranetbenelux)
   - Role: Administrator
10. When done click on 'Add'
11. Click on 'Add' and fill in the following:
   - User or group: Project Collection Build Service (claranetbenelux)
   - Role: Administrator
12. When done click on 'Add'
13. On the top click on de 'save icon' (floppy disk)

## Manual run

1. Go to pipeline and click 'Run new'
2. Fill in the parameters and click 'Run'
