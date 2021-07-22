resource "aws_dynamodb_table" "example" {
  name = "Result"
  billing_mode = "PROVISIONED"
  read_capacity = 5
  write_capacity = 5
  hash_key = "exampleID"

  attribute {
    name = "exampleID"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled = false
  }

  tags = {
    Environment = var.acc_env
  }
}

resource "aws_dynamodb_table_item" "example" {
  table_name = aws_dynamodb_table.example.name
  hash_key   = aws_dynamodb_table.example.hash_key

  item = <<ITEM
{
  "exampleID": {"S": "1"},
  "root_var": {"S": "${var.root_var}"},
  "acc_env": {"S": "${var.acc_env}"},
  "Xreg_stack_lambda_source": {"S": "${var.Xreg_stack_lambda_source}"},
  "reg_baller_vpc": {"S": "${var.reg_baller_vpc}"},
  "this_region_stack": {"S": "${var.this_region_stack}"}
}
ITEM
}
