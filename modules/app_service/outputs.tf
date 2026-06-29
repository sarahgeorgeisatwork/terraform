output "app_service_id" {
  value = azurerm_app_service.main.id
}

output "app_service_name" {
  value = azurerm_app_service.main.name
}

output "app_service_url" {
  value = "https://${azurerm_app_service.main.default_site_hostname}"
}

output "app_service_plan_id" {
  value = azurerm_app_service_plan.main.id
}

output "principal_id" {
  value = azurerm_app_service_identity.main.principal_id
}
