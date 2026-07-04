# variable "rg_name" {
#   description = "Azure resource group name"
#   type        = string
#   default     = "newrg"
# }

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "uksouth"
}

variable "resource_prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "home"
}

variable "abbr_location" {
  description = "Abbreviated location code (auto-derived from location)"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "terraform"
}

variable "repo" {
  description = "Repository name"
  type        = string
  default     = "Terraform"
}

variable "resource_groups" {
  description = "Map of resource groups to create"
  type = map(object({
    location = optional(string)
  }))
  default = {}
}

variable "vnets" {
  description = "Map of VNets to create"
  type = map(object({
    resource_group = string
    location       = optional(string)
    address_space  = string
    subnets        = map(string)
  }))
  default = {}
}