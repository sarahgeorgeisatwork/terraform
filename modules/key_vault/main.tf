data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                            = "${var.resource_prefix}-kv-${var.environment}"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  enabled_for_disk_encryption     = true
  purge_protection_enabled        = true
  soft_delete_retention_days      = 7
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = "standard"

  tags = var.common_tags
}

# Access policy for current user/service principal
resource "azurerm_key_vault_access_policy" "terraform" {
  key_vault_id       = azurerm_key_vault.main.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Update",
    "Verify",
    "WrapKey",
  ]

  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set",
  ]

  certificate_permissions = [
    "Backup",
    "Create",
    "Delete",
    "DeleteIssuers",
    "Get",
    "GetIssuers",
    "Import",
    "List",
    "ListIssuers",
    "ManageContacts",
    "ManageIssuers",
    "Purge",
    "Recover",
    "Restore",
    "SetIssuers",
    "Update",
  ]
}

# Access policies for additional users/service principals
resource "azurerm_key_vault_access_policy" "additional" {
  for_each = toset(var.key_vault_access_object_ids)

  key_vault_id       = azurerm_key_vault.main.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = each.value

  secret_permissions = [
    "Get",
    "List",
  ]
}

# Network rules (optional - commented out for open access)
resource "azurerm_key_vault_network_acl" "main" {
  key_vault_id       = azurerm_key_vault.main.id
  default_action     = "Allow"
  bypass             = "AzureServices"
}
