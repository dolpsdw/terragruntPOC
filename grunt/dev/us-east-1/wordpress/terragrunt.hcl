# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  # Automatically load cross wordpress-X-region vars
  cross_region_vars = read_terragrunt_config(find_in_parent_folders("wordpress-X-region.hcl"))

  # Extract out common variables for reuse
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "${get_parent_terragrunt_dir()}/../stacks/wordpress"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = merge(
  local.cross_region_vars.locals ,
  {this_region_stack = "from us-east1-wordpress"}
)
