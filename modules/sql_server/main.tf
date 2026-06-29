resource "azurerm_mssql_server" "main" {
  name                         = "${var.resource_prefix}-sql-${var.environment}"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
  minimum_tls_version          = "1.2"

  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags
}

# Allow Azure services to access SQL Server
resource "azurerm_mssql_firewall_rule" "azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Create database
resource "azurerm_mssql_database" "main" {
  name           = "${var.resource_prefix}-db-${var.environment}"
  server_id      = azurerm_mssql_server.main.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  sku_name       = "S0"
  zone_redundant = false

  tags = var.common_tags

  # Prevent accidental deletion
  lifecycle {
    prevent_destroy = true
  }
}

# Backup retention policy
resource "azurerm_mssql_database_extended_auditing_policy" "main" {
  database_id                             = azurerm_mssql_database.main.id
  enabled                                 = true
  storage_endpoint                        = "" # Can be configured for audit logs
  retention_in_days                       = 30
  log_monitoring_enabled                  = true
}

# Store connection string in Key Vault
resource "azurerm_key_vault_secret" "sql_connection_string" {
  name         = "sql-connection-string"
  value        = "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.main.name};Persist Security Info=False;User ID=${var.sql_admin_username};Password=${var.sql_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  key_vault_id = var.key_vault_id
}
