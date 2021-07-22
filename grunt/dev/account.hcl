# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name   = "dev"
  aws_account_id = "784614627581" # TODO: replace me with your AWS account ID!
  aws_profile    = "dev"
  access_key = "KIA3NLVNDD6ZMKRJBMN"
  secret_key = "nkBNND5yd0460CqvMWf4zEk239EVd6LN3MyOwjo"
}
