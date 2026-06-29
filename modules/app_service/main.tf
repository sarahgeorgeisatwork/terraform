resource "azurerm_app_service_plan" "main" {
  name                = "${var.resource_prefix}-asp-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = split("", var.app_service_plan_sku_name)[0]
    size = var.app_service_plan_sku_name
  }

  tags = var.common_tags
}

resource "azurerm_app_service" "main" {
  name                = "${var.resource_prefix}-app-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.main.id

  https_only = true

  site_config {
    dotnet_framework_version = "v8.0"
    http2_enabled            = true
    min_tls_version          = "1.2"

    cors {
      allowed_origins = ["*"]
    }

    app_command_line = "dotnet DocumentSummarizer.dll"
  }

  app_settings = {
    "ASPNETCORE_ENVIRONMENT"              = var.environment
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.app_insights_connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
    "XDT_MicrosoftApplicationInsights_Mode" = "recommended"
  }

  connection_string {
    name             = "DefaultConnection"
    type             = "SQLAzure"
    connection_value = var.sql_connection_string
  }

  tags = var.common_tags

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITES_ENABLE_APP_SERVICE_STORAGE"],
      app_settings["WEBSITE_RUN_FROM_PACKAGE"]
    ]
  }
}

resource "azurerm_app_service_slot" "staging" {
  name                = "staging"
  app_service_name    = azurerm_app_service.main.name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.main.id

  https_only = true

  site_config {
    dotnet_framework_version = "v8.0"
    http2_enabled            = true
    min_tls_version          = "1.2"
  }

  app_settings = {
    "ASPNETCORE_ENVIRONMENT"              = "staging"
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.app_insights_connection_string
  }

  connection_string {
    name             = "DefaultConnection"
    type             = "SQLAzure"
    connection_value = var.sql_connection_string
  }

  tags = var.common_tags
}

# Key Vault Secrets for sensitive configuration
resource "azurerm_app_service_slot_config_appsettings" "main" {
  resource_group_name     = var.resource_group_name
  app_service_slot_id     = azurerm_app_service.main.id
  app_service_plan_id     = azurerm_app_service_plan.main.id
  app_settings = {
    "StorageConnectionString" = var.storage_account_connection
    "OpenAIEndpoint"          = var.openai_endpoint
    "OpenAIApiKey"            = var.openai_api_key
    "StorageContainerName"    = var.storage_container_name
    "KeyVaultUri"             = var.key_vault_uri
  }
}

# Enable Managed Identity
resource "azurerm_app_service_slot_config_appsettings" "identity" {
  resource_group_name     = var.resource_group_name
  app_service_slot_id     = azurerm_app_service.main.id
  app_service_plan_id     = azurerm_app_service_plan.main.id

  app_settings = {}
}

resource "azurerm_app_service_identity" "main" {
  app_service_id = azurerm_app_service.main.id
  type           = "SystemAssigned"
}
