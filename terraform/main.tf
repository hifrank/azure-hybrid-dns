provider "azurerm" {
  features {}
  alias = "connectivity"
  # my MSDN
  subscription_id = "<Subscription for DNS private zone resource>"
}

provider "azurerm" {
  features {}
  alias = "dns_policy"
  # my MSDN
  subscription_id = "<Subscription for Policy resource, ex, Managed Identity, Management Group policy assignment>"
}

module "dns_for_priv_endpoint" {
  source = "./modules/azure-private-dns-zone-for-private-endpoint"
  providers = {
    # subscription for private DNS zone
    azurerm.dns_subscription = azurerm.connectivity
    # subscription for management group
    azurerm.dns_policy_subscription = azurerm.dns_policy
  }
  #root managemnet group
  management_group_id = "<Management group id to attach policy>"
  dns_hub_vnet_id     = "<VNet to link priavte zone>"
}
