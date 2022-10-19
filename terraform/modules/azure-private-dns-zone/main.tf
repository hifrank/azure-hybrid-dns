locals {
  dns_app_service_name  = "privatelink.azurewebsites.net"
  dns_storage_blob_name = "privatelink.blob.core.windows.net"
}
# 1. create private zone & link
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

# 2. assign policy 
# policy for app service
resource "azurerm_management_group_policy_assignment" "app_service" {
  count = (var.enable_policy && var.dns_name == local.dns_app_service_name ? 1 : 0)

  provider             = azurerm.dns_subscription
  name                 = "dns_app_service"
  display_name         = "(Terraform)Configure App Service apps to use private DNS zones"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b318f84a-b872-429b-ac6d-a01b96814452"
  management_group_id  = var.management_group_id
  location             = var.location

  identity {
    type         = "UserAssigned"
    identity_ids = [var.policy_mi_id]
  }
  parameters = <<PARAMS
    {
      "privateDnsZoneId": {
        "value": "${azurerm_private_dns_zone.this.id}"
      },
      "effect": {
        "value": "DeployIfNotExists"
      }
    }
PARAMS

}


resource "azurerm_management_group_policy_assignment" "storage_blob" {
  count                = (var.enable_policy && var.dns_name == local.dns_storage_blob_name ? 1 : 0)
  provider             = azurerm.dns_subscription
  name                 = "dns_storage_blob"
  display_name         = "(Terraform)Configure Stoarge Blob to use private DNS zones"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/75973700-529f-4de2-b794-fb9b6781b6b0"
  management_group_id  = var.management_group_id
  location             = var.location

  identity {
    type         = "UserAssigned"
    identity_ids = [var.policy_mi_id]
  }
  parameters = <<PARAMS
    {
      "privateDnsZoneId": {
        "value": "${azurerm_private_dns_zone.this.id}"
      },
      "effect": {
        "value": "DeployIfNotExists"
      }
    }
PARAMS

}

resource "azurerm_management_group_policy_assignment" "storage_blob_sec" {
  count                = (var.enable_policy && var.dns_name == local.dns_storage_blob_name ? 1 : 0)
  provider             = azurerm.dns_subscription
  name                 = "dns_storage_blob_sec"
  display_name         = "(Terraform)Configure Stoarge Blob Secondary to use private DNS zones"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/d847d34b-9337-4e2d-99a5-767e5ac9c582"
  management_group_id  = var.management_group_id
  location             = var.location

  identity {
    type         = "UserAssigned"
    identity_ids = [var.policy_mi_id]
  }
  parameters = <<PARAMS
    {
      "privateDnsZoneId": {
        "value": "${azurerm_private_dns_zone.this.id}"
      },
      "effect": {
        "value": "DeployIfNotExists"
      }
    }
PARAMS
}
