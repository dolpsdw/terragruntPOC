# This module is defining a STACK with its own configs, and will be copied to every account/region/stack tfstate
# Terraform code is common for each tfstate
# But can be potentialy overriden by local files like account/region/stack/FILE_TO_OVERRIDE.tf
module "reusable_gateway" {
  source = "C:/GIT/terragrunt/tf_modules/learn-terraform-lambda-api-gateway-final"

  aws_region = var.aws_region
}

module "dynamo_test" {
  source = "./child"
  #root terragrunt.hcl
  root_var = var.grunt_folder
  #account environment vars
  acc_env = var.account_name
  #cross region stack vars
  Xreg_stack_lambda_source = var.lambda_source
  #region common vars
  reg_baller_vpc = var.baller_vpc
  #stack vars
  this_region_stack = var.this_region_stack

}
