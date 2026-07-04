# Create multiple resource groups using for_each
module "resource_group" {
  for_each = var.resource_groups

  source = "./modules/resource_group"

  resource_group_name = "${var.resource_prefix}-${each.key}-${var.environment}-${local.abbr_location}-rg"
  location            = each.value.location != null ? each.value.location : var.location
  tags                = merge(local.common_tags, { ResourceGroup = each.key })
}