resource "azurerm_storage_account" "storage_account" {
  name                             = var.name
  resource_group_name              = var.resource_group_name
  location                         = var.location
  account_kind                     = var.account_kind
  account_tier                     = var.account_tier
  account_replication_type         = var.account_replication_type
  cross_tenant_replication_enabled = var.cross_tenant_replication_enabled
  access_tier                      = var.access_tier
  edge_zone                        = var.edge_zone
  https_traffic_only_enabled       = var.https_traffic_only_enabled
  min_tls_version                  = var.min_tls_version
  allow_nested_items_to_be_public  = var.allow_nested_items_to_be_public
  shared_access_key_enabled        = var.shared_access_key_enabled
  public_network_access_enabled    = var.public_network_access_enabled
  default_to_oauth_authentication  = var.default_to_oauth_authentication
  is_hns_enabled                   = var.is_hns_enabled
  nfsv3_enabled                    = var.nfsv3_enabled
  dynamic "custom_domain" {
    for_each = var.custom_domain != null ? [var.custom_domain] : []
    content {
      name          = custom_domain.value.name
      use_subdomain = custom_domain.value.use_subdomain
    }
  }
  dynamic "customer_managed_key" {
    for_each = var.customer_managed_key != null ? [var.customer_managed_key] : []
    content {
      key_vault_key_id          = customer_managed_key.value.key_vault_key_id
      managed_hsm_key_id        = customer_managed_key.value.manamanaged_hsm_key_id
      user_assigned_identity_id = customer_managed_key.value.manamanaged_hsm_key_id
    }
  }
  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
  dynamic "blob_properties" {
    for_each = var.blob_properties != null ? [var.blob_properties] : []
    content {
      dynamic "container_delete_retention_policy" {
        for_each = blob_properties.value.container_delete_retention_policy != null ? [blob_properties.value.container_delete_retention_policy] : []
        content {
          days = container_delete_retention_policy.value.days
        }
      }

      dynamic "delete_retention_policy" {
        for_each = blob_properties.value.delete_retention_policy != null ? [blob_properties.value.delete_retention_policy] : []
        content {
          days = delete_retention_policy.value.days
        }
      }
    }
  }
  dynamic "network_rules" {
    for_each = var.network_rules != null ? [var.network_rules] : []
    content {
      bypass                     = network_rules.value.bypass
      default_action             = network_rules.value.default_action
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids
    }
  }
  dynamic "sas_policy" {
    for_each = var.sas_policy != null ? [var.sas_policy] : []
    content {
      expiration_action = sas_policy.value.expiration_action
      expiration_period = sas_policy.value.expiration_period
    }
  }
  tags = var.tags
}
