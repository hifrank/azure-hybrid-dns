## private dns zone for app service
resource "azurerm_private_dns_zone" "this" {
  provider = azurerm.dns_subscription

  name                = var.dns_name
  resource_group_name = var.rg_name
}
## link to hub vnet
resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  provider = azurerm.dns_subscription

  resource_group_name   = var.rg_name
  name                  = "${var.dns_name}-to-hub-vnet"
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = var.dns_hub_vnet_id
}
