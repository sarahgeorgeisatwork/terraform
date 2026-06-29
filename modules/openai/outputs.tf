output "openai_id" {
  value = azurerm_cognitive_account.openai.id
}

output "endpoint" {
  value = azurerm_cognitive_account.openai.endpoint
}

output "api_key" {
  value     = azurerm_cognitive_account.openai.primary_access_key
  sensitive = true
}

output "api_key_secondary" {
  value     = azurerm_cognitive_account.openai.secondary_access_key
  sensitive = true
}

output "deployment_name" {
  value = azurerm_cognitive_deployment.gpt35.name
}
