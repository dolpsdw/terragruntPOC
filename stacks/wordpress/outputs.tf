# Output value definitions
output "base_url" {
  description = "Base URL for API Gateway stage."

  value = module.reusable_gateway.base_url
}
