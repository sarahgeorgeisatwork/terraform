output "app_service_url" {
  description = "URL of the App Service"
  value       = module.app_service.app_service_url
}

output "app_service_name" {
  description = "Name of the App Service"
  value       = module.app_service.app_service_name
}

output "sql_server_fqdn" {
  description = "FQDN of SQL Server"
  value       = module.sql_server.sql_server_fqdn
}

output "storage_account_name" {
  description = "Name of storage account"
  value       = module.storage_account.storage_account_name
}

output "storage_account_primary_endpoint" {
  description = "Primary blob endpoint of storage account"
  value       = module.storage_account.storage_account_primary_endpoint
}

output "openai_endpoint" {
  description = "Azure OpenAI endpoint"
  value       = module.openai.endpoint
}

output "openai_deployment_name" {
  description = "Azure OpenAI deployment name"
  value       = module.openai.deployment_name
}

output "app_insights_instrumentation_key" {
  description = "Application Insights instrumentation key"
  value       = module.app_insights.instrumentation_key
  sensitive   = true
}

output "key_vault_uri" {
  description = "URI of Key Vault"
  value       = module.key_vault.key_vault_uri
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}
