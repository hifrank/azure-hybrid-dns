########## 1. general setting 
# 1.1 resource group for private DNS zone
resource "azurerm_resource_group" "rg_dns" {
  provider = azurerm.dns_subscription

  name     = var.private_dns_zone_rg
  location = var.location
}
# 1.2 create MI for DNS policy and assign permission to MI.
# create Azure MI for private DNS zone update 
resource "azurerm_user_assigned_identity" "private_dns_policy_mi" {
  provider = azurerm.dns_subscription

  resource_group_name = azurerm_resource_group.rg_dns.name
  location            = var.location
  name                = var.dns_policy_mi_name
}

## 1.3 assign permission to policy mi
resource "azurerm_role_assignment" "private_dns_policy_mi" {
  provider = azurerm.dns_policy_subscription

  scope = var.management_group_id
  # Network contributor
  #role_definition_id = "/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7"
  role_definition_name = "Network contributor"
  principal_id         = azurerm_user_assigned_identity.private_dns_policy_mi.principal_id
}

########## 2. create DNS zone and policy for maintain dns config
# 2.1 create private DNS zone/policy
# app service
module "dns_zone_app_service" {
  providers = {
    # subscription for private DNS zone
    azurerm.dns_subscription = azurerm.dns_subscription
  }

  source          = "../azure-private-dns-zone"
  dns_name        = "privatelink.azurewebsites.net"
  rg_name         = azurerm_resource_group.rg_dns.name
  dns_hub_vnet_id = var.dns_hub_vnet_id
}
# 2. assign policy 
resource "azurerm_management_group_policy_assignment" "dns_app_service" {
  provider             = azurerm.dns_policy_subscription
  name                 = "dns_app_service"
  display_name         = "(Terraform)Configure App Service apps to use private DNS zones"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b318f84a-b872-429b-ac6d-a01b96814452"
  management_group_id  = var.management_group_id
  location             = var.location

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.private_dns_policy_mi.id]
  }
  parameters = <<PARAMS
    {
      "privateDnsZoneId": {
        "value": "${module.dns_zone_app_service.dns_zone_id}"
      },
      "effect": {
        "value": "DeployIfNotExists"
      }
    }
PARAMS

}

# storage blob
module "dns_zone_storage_blob" {
  providers = {
    # subscription for private DNS zone
    azurerm.dns_subscription = azurerm.dns_subscription
  }

  source          = "../azure-private-dns-zone"
  dns_name        = "privatelink.blob.core.windows.net"
  rg_name         = azurerm_resource_group.rg_dns.name
  dns_hub_vnet_id = var.dns_hub_vnet_id
}

resource "azurerm_management_group_policy_assignment" "dns_storage_blob" {
  provider             = azurerm.dns_policy_subscription
  name                 = "dns_storage_blob"
  display_name         = "(Terraform)Configure Stoarge Blob to use private DNS zones"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/75973700-529f-4de2-b794-fb9b6781b6b0"
  management_group_id  = var.management_group_id
  location             = var.location

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.private_dns_policy_mi.id]
  }
  parameters = <<PARAMS
    {
      "privateDnsZoneId": {
        "value": "${module.dns_zone_storage_blob.dns_zone_id}"
      },
      "effect": {
        "value": "DeployIfNotExists"
      }
    }
PARAMS

}

resource "azurerm_management_group_policy_assignment" "dns_storage_blob_secondary" {
  provider             = azurerm.dns_policy_subscription
  name                 = "dns_storage_blob_sec"
  display_name         = "(Terraform)Configure Stoarge Blob Secondary to use private DNS zones"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/d847d34b-9337-4e2d-99a5-767e5ac9c582"
  management_group_id  = var.management_group_id
  location             = var.location

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.private_dns_policy_mi.id]
  }
  parameters = <<PARAMS
    {
      "privateDnsZoneId": {
        "value": "${module.dns_zone_storage_blob.dns_zone_id}"
      },
      "effect": {
        "value": "DeployIfNotExists"
      }
    }
PARAMS

}
