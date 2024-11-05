resource "azurerm_redis_cache" "redis_cache_instance" {
  name                               = var.name
  location                           = var.location
  resource_group_name                = var.resource_group_name
  capacity                           = var.capacity
  family                             = var.family
  sku_name                           = var.sku_name
  access_keys_authentication_enabled = var.access_keys_authentication_enabled
  non_ssl_port_enabled               = var.non_ssl_port_enabled
  identity {
    type         = var.identity.type
    identity_ids = var.identity.identity_ids
  }
  minimum_tls_version = var.minimum_tls_version
  dynamic "patch_schedules" {
    for_each = var.patch_schedules != null ? [var.patch_schedules] : []
    content {
      day_of_week        = patch_schedules.value.day_of_week
      maintenance_window = patch_schedules.value.maintenance_window
      start_hour_utc     = patch_schedules.value.day_of_week.start_hour_utc
    }
  }
  private_static_ip_address     = var.private_static_ip_address
  public_network_access_enabled = var.public_network_access_enabled
  redis_configuration {
    aof_backup_enabled                      = var.redis_configuration.aof_backup_enabled
    aof_storage_connection_string_0         = var.redis_configuration.aof_storage_connection_string_0
    aof_storage_connection_string_1         = var.redis_configuration.aof_storage_connection_string_1
    authentication_enabled                  = var.redis_configuration.authentication_enabled
    active_directory_authentication_enabled = var.redis_configuration.authentication_enabled
    maxmemory_reserved                      = var.redis_configuration.maxmemory_reserved
    maxmemory_delta                         = var.redis_configuration.maxmemory_delta
    maxmemory_policy                        = var.redis_configuration.maxmemory_policy
    data_persistence_authentication_method  = var.redis_configuration.data_persistence_authentication_method
    maxfragmentationmemory_reserved         = var.redis_configuration.maxfragmentationmemory_reserved
    rdb_backup_enabled                      = var.redis_configuration.rdb_backup_enabled
    rdb_backup_frequency                    = var.redis_configuration.rdb_backup_frequency
    rdb_backup_max_snapshot_count           = var.redis_configuration.rdb_backup_max_snapshot_count
    rdb_storage_connection_string           = var.redis_configuration.rdb_storage_connection_string
    storage_account_subscription_id         = var.redis_configuration.storage_account_subscription_id
    notify_keyspace_events                  = var.redis_configuration.notify_keyspace_events
  }
  replicas_per_master  = var.replicas_per_master
  replicas_per_primary = var.replicas_per_primary
  redis_version        = var.redis_version
  tenant_settings      = var.tenant_settings
  shard_count          = var.shard_count
  subnet_id            = var.subnet_id
  tags                 = var.tags
  zones                = var.zones
}
