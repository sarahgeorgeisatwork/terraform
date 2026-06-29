output "storage_account_id" {
  value = azurerm_storage_account.main.id
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "storage_account_primary_endpoint" {
  value = azurerm_storage_account.main.primary_blob_endpoint
}

output "connection_string" {
  value     = azurerm_storage_account.main.primary_connection_string
  sensitive = true
}

output "document_container_name" {
  value = azurerm_storage_container.documents.name
}
