# Variables that apply to all the stacks on the region. This is automatically pulled in in the root terragrunt.hcl configuration to
# configure the remote state bucket and pass forward to the child modules as inputs.
locals {
  aws_region = "us-east-1"
  baller_vpc = "vpc-5ad62d27"
}
