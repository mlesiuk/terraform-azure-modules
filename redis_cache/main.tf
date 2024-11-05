resource "azurerm_redis_cache" "redis_cache_instance" {
  name                               = var.name
  resource_group_name                = var.resource_group_name
  location                           = var.location
  capacity                           = var.capacity
  family                             = var.family
  sku_name                           = var.sku_name
  non_ssl_port_enabled               = var.non_ssl_port_enabled
  access_keys_authentication_enabled = var.access_keys_authentication_enabled
  minimum_tls_version                = var.minimum_tls_version
  private_static_ip_address          = var.private_static_ip_address
  public_network_access_enabled      = var.public_network_access_enabled
  redis_version                      = var.redis_version
  tags                               = var.tags

  identity {
    type         = var.identity.type
    identity_ids = var.identity.identity_ids
  }

  dynamic "patch_schedules" {
    for_each = var.patch_schedules != null ? [var.patch_schedules] : []
    content {
      day_of_week        = patch_schedules.value.day_of_week
      maintenance_window = patch_schedules.value.maintenance_window
      start_hour_utc     = patch_schedules.value.day_of_week.start_hour_utc
    }
  }

  redis_configuration {
    maxmemory_reserved              = var.redis_configuration.maxmemory_reserved
    maxmemory_delta                 = var.redis_configuration.maxmemory_delta
    maxfragmentationmemory_reserved = var.redis_configuration.maxfragmentationmemory_reserved
    maxmemory_policy                = var.redis_configuration.maxmemory_policy
  }
}
