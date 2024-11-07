resource "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  minimal_tls_version = var.minimal_tls_version
  offer_type          = var.offer_type
  dynamic "analytical_storage" {
    for_each = var.analytical_storage != null ? [var.analytical_storage] : []
    content {
      schema_type = analytical_storage.value.schema_type
    }
  }
  dynamic "capacity" {
    for_each = var.capacity != null ? [var.capacity] : []
    content {
      total_throughput_limit = capacity.value.tototal_throughput_limit
    }
  }
  create_mode           = var.create_mode
  default_identity_type = var.default_identity_type
  kind                  = var.kind
  dynamic "consistency_policy" {
    for_each = var.consistency_policy != null ? [var.consistency_policy] : []
    content {
      consistency_level       = consistency_policy.value.consistency_level
      max_interval_in_seconds = consistency_policy.value.max_interval_in_seconds
      max_staleness_prefix    = consistency_policy.value.max_staleness_prefix
    }
  }
  dynamic "geo_location" {
    for_each = var.geo_location != null ? [var.geo_location] : []
    content {
      location          = geo_location.value.location
      failover_priority = geo_location.value.failover_priority
      zone_redundant    = geo_location.value.zone_redundant != null ? geo_location.value.zone_redundant : false
    }
  }
  ip_range_filter               = var.ip_range_filter
  free_tier_enabled             = var.free_tier_enabled
  analytical_storage_enabled    = var.analytical_storage_enabled
  automatic_failover_enabled    = var.automatic_failover_enabled
  partition_merge_enabled       = var.partition_merge_enabled
  burst_capacity_enabled        = var.burst_capacity_enabled
  public_network_access_enabled = var.public_network_access_enabled
  dynamic "capabilities" {
    for_each = var.capabilities != null ? [var.capabilities] : []
    content {
      name = capabilities.value.name
    }
  }
  is_virtual_network_filter_enabled = var.is_virtual_network_filter_enabled
  key_vault_key_id                  = var.key_vault_key_id
  dynamic "virtual_network_rule" {
    for_each = var.virtual_network_rules
    content {
      id                                   = virtual_network_rule.value.id
      ignore_missing_vnet_service_endpoint = virtual_network_rule.value.ignore_missing_vnet_service_endpoint != null ? virtual_network_rule.value.ignore_missing_vnet_service_endpoint : false
    }
  }
  multiple_write_locations_enabled      = var.multiple_write_locations_enabled
  access_key_metadata_writes_enabled    = var.access_key_metadata_writes_enabled
  mongo_server_version                  = var.mongo_server_version
  network_acl_bypass_for_azure_services = var.network_acl_bypass_for_azure_services
  network_acl_bypass_ids                = var.network_acl_bypass_ids
  local_authentication_disabled         = var.local_authentication_disabled
  dynamic "backup" {
    for_each = var.backup != null ? [var.backup] : []
    content {
      type                = backup.value.type
      storage_redundancy  = backup.value.storage_redundancy
      interval_in_minutes = backup.value.interval_in_minutes
      retention_in_hours  = backup.value.retention_in_hours
    }
  }
  dynamic "cors" {
    for_each = var.cors != null ? [var.cors] : []
    content {
      allowed_headers    = cors.value.allowed_headers
      allowed_methods    = cors.value.allowed_methods
      allowed_origins    = cors.value.allowed_origins
      exposed_headers    = cors.value.exposed_headers
      max_age_in_seconds = cors.value.max_age_in_seconds
    }
  }
  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
  dynamic "restore" {
    for_each = var.restore != null ? [var.restore] : []
    content {
      source_cosmosdb_account_id = restore.value.source_cosmosdb_account_id
      restore_timestamp_in_utc   = restore.value.restore_timestamp_in_utc
      tables_to_restore          = restore.value.tables_to_restore
      dynamic "database" {
        for_each = restore.value.database != null ? [restore.value.database] : []
        content {
          name             = database.value.name
          collection_names = database.value.collection_names
        }
      }
      dynamic "gremlin_database" {
        for_each = restore.value.gremlin_database != null ? [restore.value.gremlin_database] : []
        content {
          name        = gremlin_database.value.name
          graph_names = gremlin_database.value.graph_names
        }
      }
    }
  }
}
