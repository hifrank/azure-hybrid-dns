terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.27.0"
      configuration_aliases = [ 
        azurerm.dns_subscription,
        azurerm.dns_policy_subscription
      ]
    }
  }
}