# Create multiple VNets using for_each
module "vnet" {
  for_each = var.vnets
  source   = "./modules/vnet"

  vnet_name           = "${var.resource_prefix}-${each.key}-${var.environment}-vnet"
  location            = each.value.location != null ? each.value.location : var.location
  resource_group_name = module.resource_group[each.value.resource_group].name
  address_space       = each.value.address_space
  subnets             = each.value.subnets

  tags = merge(local.common_tags, { Component = "Networking", VNet = each.key })
}
