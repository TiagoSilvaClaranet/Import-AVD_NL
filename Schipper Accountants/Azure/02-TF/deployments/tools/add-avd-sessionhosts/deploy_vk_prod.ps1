write-output "Please note : Terraform state files must not be present to deploy new servers"
terraform apply --var-file="vk-prd.tfvars"