# Sample Landing Zone for an AVD Spoke

# Azure Virtual Desktop resources deployed:
- 4 Host pools (dev/test/uat/prod)
- 4 Desktop Application Groups
- 1 Workspace combining these DAG's
- 1 Log Analytics Workspace
- Diagnostics settings for Hostpool, DAG and Workspaces when log_analytics_workspace_id is parsed

- Azure AD authentication is enabled by default 
    (Prerequisites are AD-Connect configured for Hybrid AD Join and Azure AD Kerberos should be enabled) (Is this needed for deployment or only for operation)

TODO
-  AVD Scaling plans
- Azure FSLogix fileshares
- Key vault
- Private endpoint