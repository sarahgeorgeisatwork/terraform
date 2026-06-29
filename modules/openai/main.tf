resource "azurerm_cognitive_account" "openai" {
  name                  = "${var.resource_prefix}-openai-${var.environment}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  kind                  = "OpenAI"
  sku_name              = var.openai_sku_name

  tags = var.common_tags
}

# Deploy GPT model for summarization
resource "azurerm_cognitive_deployment" "gpt35" {
  cognitive_account_id = azurerm_cognitive_account.openai.id
  name                 = "gpt-35-turbo-summary"
  model_name           = "gpt-35-turbo"
  model_format         = "OpenAI"
  model_version        = "0613"
  scale_settings {
    scale_type = "Standard"
  }
}

# Deploy text embedding model for similarity search (optional)
resource "azurerm_cognitive_deployment" "embedding" {
  cognitive_account_id = azurerm_cognitive_account.openai.id
  name                 = "text-embedding-ada-002"
  model_name           = "text-embedding-ada-002"
  model_format         = "OpenAI"
  model_version        = "2"
  scale_settings {
    scale_type = "Standard"
  }
}

# Store OpenAI credentials in Key Vault
resource "azurerm_key_vault_secret" "openai_key" {
  name         = "openai-api-key"
  value        = azurerm_cognitive_account.openai.primary_access_key
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "openai_endpoint" {
  name         = "openai-endpoint"
  value        = azurerm_cognitive_account.openai.endpoint
  key_vault_id = var.key_vault_id
}
