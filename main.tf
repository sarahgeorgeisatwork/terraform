

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

locals {
  common_tags = {
    Environment = var.environment
    Project     = "DocumentSummarizer"
    ManagedBy   = "Terraform"
  }
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.resource_prefix}-rg-${var.environment}"
  location = var.location

  tags = local.common_tags
}

# App Insights
module "app_insights" {
  source = "./modules/app_insights"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  resource_prefix     = var.resource_prefix
  environment         = var.environment
  common_tags         = local.common_tags
}

# Key Vault
module "key_vault" {
  source = "./modules/key_vault"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  resource_prefix     = var.resource_prefix
  environment         = var.environment
  common_tags         = local.common_tags

  key_vault_access_object_ids = var.key_vault_access_object_ids
}

# SQL Server
module "sql_server" {
  source = "./modules/sql_server"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  resource_prefix     = var.resource_prefix
  environment         = var.environment
  common_tags         = local.common_tags
  sql_admin_username  = var.sql_admin_username
  sql_admin_password  = random_password.sql_admin_password.result
  key_vault_id        = module.key_vault.key_vault_id
}

# Storage Account
module "storage_account" {
  source = "./modules/storage_account"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  resource_prefix     = var.resource_prefix
  environment         = var.environment
  common_tags         = local.common_tags
  key_vault_id        = module.key_vault.key_vault_id
}

# Azure OpenAI
module "openai" {
  source = "./modules/openai"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.openai_location
  resource_prefix     = var.resource_prefix
  environment         = var.environment
  common_tags         = local.common_tags
  openai_sku_name     = var.openai_sku_name
  key_vault_id        = module.key_vault.key_vault_id
}

# App Service Plan
module "app_service" {
  source = "./modules/app_service"

  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  resource_prefix            = var.resource_prefix
  environment                = var.environment
  common_tags                = local.common_tags
  app_service_plan_sku_name  = var.app_service_plan_sku_name

  app_insights_connection_string = module.app_insights.app_insights_connection_string
  sql_connection_string          = module.sql_server.connection_string
  storage_account_connection     = module.storage_account.connection_string
  openai_endpoint                = module.openai.endpoint
  openai_api_key                 = module.openai.api_key
  storage_container_name         = module.storage_account.document_container_name
  key_vault_uri                  = module.key_vault.key_vault_uri

  depends_on = [
    module.key_vault,
    module.sql_server,
    module.storage_account,
    module.openai
  ]
}

# Generate random password for SQL Admin
resource "random_password" "sql_admin_password" {
  length  = 16
  special = true
}

# Store SQL password in Key Vault
resource "azurerm_key_vault_secret" "sql_admin_password" {
  name         = "sql-admin-password"
  value        = random_password.sql_admin_password.result
  key_vault_id = module.key_vault.key_vault_id
}
