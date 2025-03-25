# Login with CSP or Customer account with contributer permissions to one or more subscriptions
az login --tenant "schgoe.onmicrosoft.com"

# Set subscription context
az account set --subscription "nlc000883-schipper-prod-001"

# You can use the following AZ command te retrieve all available subscriptions
# az account list --output table
