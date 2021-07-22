# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract the variables we need for easy access
  env = local.account_vars.locals.account_name
  account_id   = local.account_vars.locals.aws_account_id
  aws_region   = local.region_vars.locals.aws_region
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${local.account_id}"]
  access_key = "${local.account_vars.locals.access_key}"
  secret_key = "${local.account_vars.locals.secret_key}"
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "tg-cog-state" #"${get_env("TG_BUCKET_PREFIX", "")}terragrunt-example-terraform-state-${local.env}-${local.aws_region}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "terraform-locks"
    access_key = "${local.account_vars.locals.access_key}"
    secret_key = "${local.account_vars.locals.secret_key}"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
local.account_vars.locals,
local.region_vars.locals,
{grunt_folder = get_parent_terragrunt_dir()}
)
# terragrunt terragrunt-info -> to verify terragrount config
/*locals {
  env = get_env("tf_env","dev")
  main_region = "eu-central-1"
  tg_inputs = read_terragrunt_config("${path_relative_from_include()}/env/${local.env}/terragrunt.hcl")
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "tg-cog-state"
    #key` must be set by the importer https://terragrunt.gruntwork.io/docs/rfc/imports/#import-block-keeping-remote-state-configuration-dry
    key = "${local.env}/${path_relative_to_include()}/terraform.tfstate"
    region         = local.main_region
    encrypt        = false
    dynamodb_table = "tg-cog-lock-table"
  }
}

generate "req_provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
provider "aws" {
  region = "${local.main_region}"
}
EOF
}

inputs = merge(local.tg_inputs)
*/
