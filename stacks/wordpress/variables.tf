# Grunt ROOT terragrunt.hcl (All accounts,regions,stacks)
variable "grunt_folder" {
  type = string
}

# Grunt ACCOUNT.HCL (All regions,stacks)
variable "account_name" {
  type = string
}
variable "aws_account_id" {
  type = string
}
variable "aws_profile" {
  type = string
}

# Grunt wordpress-X-region.hcl (specific stack inside all regions)
variable "lambda_source" {
  type = string
}

# Grunt REGION.HCL (stacks inside same region)
variable "aws_region" {
  type = string
}
variable "baller_vpc" {
  type = string
}

# Grunt region-wordpress inner terragrunt.hcl (specific stack inside specific region)
variable "this_region_stack" {
  type = string
}
