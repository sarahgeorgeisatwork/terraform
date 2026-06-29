variable "resource_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "docsumm"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "openai_location" {
  description = "Azure region for OpenAI (limited availability)"
  type        = string
  default     = "eastus"
}

variable "app_service_plan_sku_name" {
  description = "App Service Plan SKU"
  type        = string
  default     = "B2"
}

variable "openai_sku_name" {
  description = "Azure OpenAI SKU name"
  type        = string
  default     = "S0"
}

variable "sql_admin_username" {
  description = "SQL Server admin username"
  type        = string
  default     = "sqladmin"
  sensitive   = true
}

variable "key_vault_access_object_ids" {
  description = "Azure AD object IDs with Key Vault access"
  type        = list(string)
  default     = []
}

variable "enable_https_only" {
  description = "Enable HTTPS only for storage account"
  type        = bool
  default     = true
}

variable "storage_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "GRS"
}
