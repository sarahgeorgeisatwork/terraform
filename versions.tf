terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.24.0, < 4.0.0"
      configuration_aliases = [
        azurerm.azsubscription
      ]
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias = "azsubscription"
  features {}
}