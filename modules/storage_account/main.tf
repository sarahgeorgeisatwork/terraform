resource "azurerm_storage_account" "main" {
  name                     = "${var.resource_prefix}st${var.environment}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  https_only               = true
  min_tls_version          = "TLS1_2"

  blob_properties {
    cors_rule {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET", "HEAD", "POST", "OPTIONS", "PUT", "DELETE"]
      allowed_origins    = ["*"]
      exposed_headers    = ["*"]
      max_age_in_seconds = 3600
    }
  }

  tags = var.common_tags

  lifecycle {
    prevent_destroy = true
  }
}

# Document container
resource "azurerm_storage_container" "documents" {
  name                  = "documents"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# Lifecycle management - delete blobs after 90 days
resource "azurerm_storage_management_policy" "main" {
  storage_account_id = azurerm_storage_account.main.id

  rule {
    name    = "delete-old-documents"
    enabled = true

    filters {
      blob_types   = ["blockBlob"]
      prefix_match = ["documents/"]
    }

    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = 90
      }
    }
  }
}

# Storage Account encryption
resource "azurerm_storage_account_customer_managed_key" "main" {
  storage_account_id        = azurerm_storage_account.main.id
  key_vault_id              = var.key_vault_id
  key_name                  = azurerm_key_vault_key.storage.name
  user_assigned_identity_id = azurerm_user_assigned_identity.storage.id
}

resource "azurerm_user_assigned_identity" "storage" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "${var.resource_prefix}-storage-identity-${var.environment}"

  tags = var.common_tags
}

resource "azurerm_key_vault_key" "storage" {
  name             = "${var.resource_prefix}-storage-key-${var.environment}"
  key_vault_id     = var.key_vault_id
  key_type         = "RSA"
  key_size         = 2048
  key_opts         = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
}

# Key Vault permissions for storage identity
resource "azurerm_key_vault_access_policy" "storage" {
  key_vault_id       = var.key_vault_id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azurerm_user_assigned_identity.storage.principal_id
  key_permissions    = ["Get", "UnwrapKey", "WrapKey"]
}

data "azurerm_client_config" "current" {}

variable "key_vault_id" {
  type = string
}
