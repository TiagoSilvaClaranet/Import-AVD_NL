locals {
  common_tags = {
    Environment  = var.environment
    Customer     = var.nlcnumber
 
    "Deployment type"   = "Terraform"
    "Management type"   = "Terraform"
  }
}