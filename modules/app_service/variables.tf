variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "app_service_plan_sku_name" {
  type = string
}

variable "app_insights_connection_string" {
  type      = string
  sensitive = true
}

variable "sql_connection_string" {
  type      = string
  sensitive = true
}

variable "storage_account_connection" {
  type      = string
  sensitive = true
}

variable "openai_endpoint" {
  type = string
}

variable "openai_api_key" {
  type      = string
  sensitive = true
}

variable "storage_container_name" {
  type = string
}

variable "key_vault_uri" {
  type = string
}
