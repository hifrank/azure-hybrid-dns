locals {
  # Azure app service
  dns_app_service_name = "privatelink.azurewebsites.net"
  # Azure Storage
  dns_storage_blob_name  = "privatelink.blob.core.windows.net"
  dns_storage_table_name = "privatelink.table.core.windows.net"
  dns_storage_file_name  = "privatelink.file.core.windows.net"
  dns_storage_web_name   = "privatelink.web.core.windows.net"
  dns_storage_queue_name = "privatelink.queue.core.windows.net"
  # Azure SQL Database
  dns_azure_sql_name = "privatelink.database.windows.net"

  # CosmosDB
  dns_cosmos_mongo_name     = "privatelink.mongo.cosmos.azure.com"
  dns_cosmos_cassandra_name = "privatelink.cassandra.cosmos.azure.com"
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
  display_name         = "(${var.policy_name_prefix})Configure App Service apps to use private DNS zones"
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

################################################################
# policy for storage blob
resource "azurerm_management_group_policy_assignment" "storage_blob" {
  count                = (var.enable_policy && var.dns_name == local.dns_storage_blob_name ? 1 : 0)
  provider             = azurerm.dns_subscription
  name                 = "dns_storage_blob"
  display_name         = "(${var.policy_name_prefix})Configure Stoarge Blob to use private DNS zones"
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
# policy for storage blob secondary
resource "azurerm_management_group_policy_assignment" "storage_blob_sec" {
  count                = (var.enable_policy && var.dns_name == local.dns_storage_blob_name ? 1 : 0)
  provider             = azurerm.dns_subscription
  name                 = "dns_storage_blob_sec"
  display_name         = "(${var.policy_name_prefix})Configure Secondary Stoarge Blob to use private DNS zones"
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

################################################################
# policy for storage table
resource "azurerm_management_group_policy_assignment" "storage_table" {
  count                = (var.enable_policy && var.dns_name == local.dns_storage_table_name ? 1 : 0)
  provider             = azurerm.dns_subscription
  name                 = "dns_storage_table"
  display_name         = "(${var.policy_name_prefix})Configure Stoarge Table to use private DNS zones"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/028bbd88-e9b5-461f-9424-a1b63a7bee1a"
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

# policy for storage table secondary
resource "azurerm_management_group_policy_assignment" "storage_table_sec" {
  count                = (var.enable_policy && var.dns_name == local.dns_storage_table_name ? 1 : 0)
  provider             = azurerm.dns_subscription
  name                 = "dns_storage_table_sec"
  display_name         = "(${var.policy_name_prefix})Configure Secondary Stoarge Table to use private DNS zones"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/c1d634a5-f73d-4cdd-889f-2cc7006eb47f"
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
################################################################
# policy for storage file
resource "azurerm_management_group_policy_assignment" "storage_file" {
  count                = (var.enable_policy && var.dns_name == local.dns_storage_file_name ? 1 : 0)
  provider             = azurerm.dns_subscription
  name                 = "dns_storage_file"
  display_name         = "(${var.policy_name_prefix})Configure Stoarge File to use private DNS zones"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/6df98d03-368a-4438-8730-a93c4d7693d6"
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

################################################################
# policy for storage web
resource "azurerm_management_group_policy_assignment" "storage_web" {
  count                = (var.enable_policy && var.dns_name == local.dns_storage_web_name ? 1 : 0)
  provider             = azurerm.dns_subscription
  name                 = "dns_storage_web"
  display_name         = "(${var.policy_name_prefix})Configure Stoarge Web to use private DNS zones"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/9adab2a5-05ba-4fbd-831a-5bf958d04218"
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

# policy for storage web secondary
resource "azurerm_management_group_policy_assignment" "storage_web_sec" {
  count                = (var.enable_policy && var.dns_name == local.dns_storage_web_name ? 1 : 0)
  provider             = azurerm.dns_subscription
  name                 = "dns_storage_web_sec"
  display_name         = "(${var.policy_name_prefix})Configure Secondary Stoarge Web to use private DNS zones"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/d19ae5f1-b303-4b82-9ca8-7682749faf0c"
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

################################################################
# policy for storage queue
resource "azurerm_management_group_policy_assignment" "storage_queue" {
  count                = (var.enable_policy && var.dns_name == local.dns_storage_queue_name ? 1 : 0)
  provider             = azurerm.dns_subscription
  name                 = "dns_storage_queue"
  display_name         = "(${var.policy_name_prefix})Configure Stoarge queue to use private DNS zones"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/bcff79fb-2b0d-47c9-97e5-3023479b00d1"
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

resource "azurerm_management_group_policy_assignment" "storage_queue_sec" {
  count                = (var.enable_policy && var.dns_name == local.dns_storage_queue_name ? 1 : 0)
  provider             = azurerm.dns_subscription
  name                 = "dns_storage_queue_sec"
  display_name         = "(${var.policy_name_prefix})Configure Stoarge queue to use private DNS zones"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/da9b4ae8-5ddc-48c5-b9c0-25f8abf7a3d6"
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

################################################################
# policy for CosmosDB mongo
# https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-configure-private-endpoints#private-zone-name-mapping
resource "azurerm_management_group_policy_assignment" "cosmos_mongo" {
  count                = (var.enable_policy && var.dns_name == local.dns_cosmos_mongo_name ? 1 : 0)
  provider             = azurerm.dns_subscription
  name                 = "dns_cosmos_mongo"
  display_name         = "(${var.policy_name_prefix})Configure CosmosDB(mongo) to use private DNS zones"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a63cc0bd-cda4-4178-b705-37dc439d3e0f"
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
      "privateEndpointGroupId": {
        "value": "MongoDB"
      },
      "effect": {
        "value": "DeployIfNotExists"
      }
    }
PARAMS
}
################################################################
# policy for Cassandra Cassandra
# https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-configure-private-endpoints#private-zone-name-mapping
resource "azurerm_management_group_policy_assignment" "cosmos_cassandra" {
  count                = (var.enable_policy && var.dns_name == local.dns_cosmos_mongo_name ? 1 : 0)
  provider             = azurerm.dns_subscription
  name                 = "dns_cosmos_cassandra"
  display_name         = "(${var.policy_name_prefix})Configure CosmosDB(cassandra) to use private DNS zones"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a63cc0bd-cda4-4178-b705-37dc439d3e0f"
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
      "privateEndpointGroupId": {
        "value": "Cassandra"
      },
      "effect": {
        "value": "DeployIfNotExists"
      }
    }
PARAMS
}