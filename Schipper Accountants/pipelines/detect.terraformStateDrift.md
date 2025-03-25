[[_TOC_]]

# General
This pipeline is used to detect Terraform state drift for the hub deployment and sends a detailed report to Cloud Operations.

# Requirements
A user account with an Exchange Online (Kiosk) license is needed in order to send an email. Also a service principal with the correct API permissions listed below are needed in order to send a email. The user cannot have MFA required, authentication will fail.

## Service Principal
The service principal uses Microsoft Graph and a delegated user to send emails, the requirements are outlined below.

### API Permissions
The API permissions required can be found in the table below.
**IMPORTANT!: Make sure that the delegated API permissions are admin approved, otherwise a interactive logon is required to give permissions as the user**

| Permission       | Type      |
| ---------------- | --------- |
| Mail.Send        | Delegated |
| Mail.Send.Shared | Delegated |

### User Assignment
When the service principal is created and the correct API permissions are set, add the user used to send the emails to the Enterprise Application.
Azure Active Directory -> Enterprise applications -> <application used to send mail> -> Users and groups -> Add user/group -> Select the user.

## GVG_MANUAL_INFRA_AS_CODE_01
The variables that are required in this variable group are listed in the table below.

| Name                        | Value                                                                | Secret |
| --------------------------- | -------------------------------------------------------------------- | ------ |
| stateDriftapplicationId     | Application id of the enterprise application                         | No     |
| stateDriftApplicationSecret | Secret of the app registration (same name as enterprise application) | Yes    |
| stateDriftEmailAddress      | Emailaddress of the user who sends the email                         | No     |
| stateDriftEmailPassword     | Password of the user who sends the email                             | Yes    |