# Readme for deploy.newSessionHosts pipeline

[[_TOC_]]

## Requirements

### Customer Project Repo

1. Copy folder 'avd' from configurations from WorkSmart365-Azure repo to customer repo
2. Fill in <environment>.tfvars with required information
3. Add additional customizations if required to <environment>.postDeployConfig.ps1

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

1. Create Environment 'AvdNoApproval'
2. Create Environment 'AvdApproval'
3. Add Worksmart365\AVD_Approvers to 'AvdApproval' environment as approver
4. Add following variables to variable group 'GVG_MANUAL_INFRA_AS_CODE_01' and add a number value for how many session hosts you want to deploy for that environment
    - devSessionHostCount
    - tstSessionHostCount
    - uatSessionHostCount
    - prdSessionHostCount
5. Add variable 'domainControllerResourceId' to variable group 'GVG_MANUAL_INFRA_AS_CODE_01' and supply the resource id of the domain controller in Azure
6. Create new pipeline from GIT repo using an existing pipeline
7. Select pipelines\deploy.newSessionHosts.yaml
8. Rename pipeline to deploy.newSessionHosts
9. Give the 'Project Collection Build Serice (claranetbenelux)' the 'Queue builds' permission for the deploy.newSessionHosts pipeline

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
