provider "azurerm" {
  features {}
  alias = "dns_subscription"
  # my MSDN
  subscription_id = var.dns_subscription
}

provider "azurerm" {
  features {}
  alias = "dns_policy_subscription"
  # my MSDN
  subscription_id = var.dns_policy_subscription
}

module "dns_for_priv_endpoint" {
  source = "./modules/azure-private-dns-zone-for-private-endpoint"
  providers = {
    # subscription for private DNS zone
    azurerm.dns_subscription = azurerm.dns_subscription
    # subscription for management group
    azurerm.dns_policy_subscription = azurerm.dns_policy_subscription
  }
  #root managemnet group
  management_group_id = var.management_group_id
  dns_hub_vnet_id     = var.dns_hub_vnet_id
}
