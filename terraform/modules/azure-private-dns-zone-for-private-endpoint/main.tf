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

  source              = "../azure-private-dns-zone"
  dns_name            = "privatelink.azurewebsites.net"
  location            = var.location
  rg_name             = azurerm_resource_group.rg_dns.name
  dns_hub_vnet_id     = var.dns_hub_vnet_id
  management_group_id = var.management_group_id
  policy_mi_id        = azurerm_user_assigned_identity.private_dns_policy_mi.id
  enable_policy       = true
}

# storage blob
module "dns_zone_storage_blob" {
  providers = {
    # subscription for private DNS zone
    azurerm.dns_subscription = azurerm.dns_subscription
  }

  source              = "../azure-private-dns-zone"
  dns_name            = "privatelink.blob.core.windows.net"
  location            = var.location
  rg_name             = azurerm_resource_group.rg_dns.name
  dns_hub_vnet_id     = var.dns_hub_vnet_id
  management_group_id = var.management_group_id
  policy_mi_id        = azurerm_user_assigned_identity.private_dns_policy_mi.id
  enable_policy       = true
}

# storage file
module "dns_zone_storage_file" {
  providers = {
    # subscription for private DNS zone
    azurerm.dns_subscription = azurerm.dns_subscription
  }

  source              = "../azure-private-dns-zone"
  dns_name            = "privatelink.file.core.windows.net"
  location            = var.location
  rg_name             = azurerm_resource_group.rg_dns.name
  dns_hub_vnet_id     = var.dns_hub_vnet_id
  management_group_id = var.management_group_id
  policy_mi_id        = azurerm_user_assigned_identity.private_dns_policy_mi.id
  enable_policy       = true
}

# storage queue
module "dns_zone_storage_queue" {
  providers = {
    # subscription for private DNS zone
    azurerm.dns_subscription = azurerm.dns_subscription
  }

  source              = "../azure-private-dns-zone"
  dns_name            = "privatelink.queue.core.windows.net"
  location            = var.location
  rg_name             = azurerm_resource_group.rg_dns.name
  dns_hub_vnet_id     = var.dns_hub_vnet_id
  management_group_id = var.management_group_id
  policy_mi_id        = azurerm_user_assigned_identity.private_dns_policy_mi.id
  enable_policy       = true
}

# storage queue
module "dns_zone_storage_web" {
  providers = {
    # subscription for private DNS zone
    azurerm.dns_subscription = azurerm.dns_subscription
  }

  source              = "../azure-private-dns-zone"
  dns_name            = "privatelink.web.core.windows.net"
  location            = var.location
  rg_name             = azurerm_resource_group.rg_dns.name
  dns_hub_vnet_id     = var.dns_hub_vnet_id
  management_group_id = var.management_group_id
  policy_mi_id        = azurerm_user_assigned_identity.private_dns_policy_mi.id
  enable_policy       = true
}

# storage table
module "dns_zone_storage_table" {
  providers = {
    # subscription for private DNS zone
    azurerm.dns_subscription = azurerm.dns_subscription
  }

  source              = "../azure-private-dns-zone"
  dns_name            = "privatelink.table.core.windows.net"
  location            = var.location
  rg_name             = azurerm_resource_group.rg_dns.name
  dns_hub_vnet_id     = var.dns_hub_vnet_id
  management_group_id = var.management_group_id
  policy_mi_id        = azurerm_user_assigned_identity.private_dns_policy_mi.id
  enable_policy       = true
}

# Azure SQL Database
# FIXME doesn't have built in policy for now
module "dns_zone_azure_sql" {
  providers = {
    # subscription for private DNS zone
    azurerm.dns_subscription = azurerm.dns_subscription
  }

  source              = "../azure-private-dns-zone"
  dns_name            = "privatelink.database.windows.net"
  location            = var.location
  rg_name             = azurerm_resource_group.rg_dns.name
  dns_hub_vnet_id     = var.dns_hub_vnet_id
  management_group_id = var.management_group_id
  policy_mi_id        = azurerm_user_assigned_identity.private_dns_policy_mi.id
  enable_policy       = true
}

# Cosmos DB: mongo
module "dns_zone_cosmos_db_mongo" {
  providers = {
    # subscription for private DNS zone
    azurerm.dns_subscription = azurerm.dns_subscription
  }

  source              = "../azure-private-dns-zone"
  dns_name            = "privatelink.mongo.cosmos.azure.com"
  location            = var.location
  rg_name             = azurerm_resource_group.rg_dns.name
  dns_hub_vnet_id     = var.dns_hub_vnet_id
  management_group_id = var.management_group_id
  policy_mi_id        = azurerm_user_assigned_identity.private_dns_policy_mi.id
  enable_policy       = true
}

# Cosmos DB: Cassandra
module "dns_zone_cosmos_db_cassandra" {
  providers = {
    # subscription for private DNS zone
    azurerm.dns_subscription = azurerm.dns_subscription
  }

  source              = "../azure-private-dns-zone"
  dns_name            = "privatelink.cassandra.cassandra.azure.com"
  location            = var.location
  rg_name             = azurerm_resource_group.rg_dns.name
  dns_hub_vnet_id     = var.dns_hub_vnet_id
  management_group_id = var.management_group_id
  policy_mi_id        = azurerm_user_assigned_identity.private_dns_policy_mi.id
  enable_policy       = true
}

# Azure Service Bus/Azure Event Hub
module "dns_zone_service_bus" {
  providers = {
    # subscription for private DNS zone
    azurerm.dns_subscription = azurerm.dns_subscription
  }

  source              = "../azure-private-dns-zone"
  dns_name            = "privatelink.servicebus.windows.net"
  location            = var.location
  rg_name             = azurerm_resource_group.rg_dns.name
  dns_hub_vnet_id     = var.dns_hub_vnet_id
  management_group_id = var.management_group_id
  policy_mi_id        = azurerm_user_assigned_identity.private_dns_policy_mi.id
  enable_policy       = true
}

# Azure Cache for Redis
module "dns_zone_cache_redis" {
  providers = {
    # subscription for private DNS zone
    azurerm.dns_subscription = azurerm.dns_subscription
  }

  source              = "../azure-private-dns-zone"
  dns_name            = "privatelink.redis.cache.windows.net"
  location            = var.location
  rg_name             = azurerm_resource_group.rg_dns.name
  dns_hub_vnet_id     = var.dns_hub_vnet_id
  management_group_id = var.management_group_id
  policy_mi_id        = azurerm_user_assigned_identity.private_dns_policy_mi.id
  enable_policy       = true
}

# Azure Site Recovery
module "dns_zone_site_recovery" {
  providers = {
    # subscription for private DNS zone
    azurerm.dns_subscription = azurerm.dns_subscription
  }

  source              = "../azure-private-dns-zone"
  dns_name            = "privatelink.siterecovery.windowsazure.com"
  location            = var.location
  rg_name             = azurerm_resource_group.rg_dns.name
  dns_hub_vnet_id     = var.dns_hub_vnet_id
  management_group_id = var.management_group_id
  policy_mi_id        = azurerm_user_assigned_identity.private_dns_policy_mi.id
  enable_policy       = true
}

# Azure Migrate
module "dns_zone_migrate" {
  providers = {
    # subscription for private DNS zone
    azurerm.dns_subscription = azurerm.dns_subscription
  }

  source              = "../azure-private-dns-zone"
  dns_name            = "privatelink.prod.migration.windowsazure.com"
  location            = var.location
  rg_name             = azurerm_resource_group.rg_dns.name
  dns_hub_vnet_id     = var.dns_hub_vnet_id
  management_group_id = var.management_group_id
  policy_mi_id        = azurerm_user_assigned_identity.private_dns_policy_mi.id
  enable_policy       = true
}