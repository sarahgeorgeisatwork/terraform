locals {
  # Map of Azure regions to abbreviations
  location_abbr_map = {
    "eastus"             = "eus"
    "eastus2"            = "eu2"
    "westus"             = "wus"
    "westus2"            = "wu2"
    "westus3"            = "wu3"
    "centralus"          = "cus"
    "northcentralus"     = "ncu"
    "southcentralus"     = "scu"
    "uksouth"            = "uks"
    "ukwest"             = "ukw"
    "northeurope"        = "neu"
    "westeurope"         = "weu"
    "southeastasia"      = "sea"
    "eastasia"           = "eas"
    "australiaeast"      = "aue"
    "australiasoutheast" = "ause"
    "canadacentral"      = "cac"
    "canadaeast"         = "cae"
    "japaneast"          = "jae"
    "japanwest"          = "jaw"
    "koreacentral"       = "krc"
    "koreasouth"         = "krs"
  }

  # Derive abbreviation from location, fallback to first 3 chars
  abbr_location = lookup(local.location_abbr_map, lower(var.location), substr(lower(var.location), 0, 3))

  common_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = var.repo
    Location    = local.abbr_location
    CreatedDate = timestamp()
  }
}