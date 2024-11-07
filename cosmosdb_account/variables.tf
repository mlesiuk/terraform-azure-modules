variable "name" {
  description = "(Required) Specifies the name of the CosmosDB Account. Changing this forces a new resource to be created."
  type        = string
  nullable    = false
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which the CosmosDB Account is created. Changing this forces a new resource to be created."
  type        = string
  nullable    = false
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
  nullable    = false
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  nullable    = true
}

variable "minimal_tls_version" {
  description = "(Optional) Specifies the minimal TLS version for the CosmosDB account. Possible values are: Tls, Tls11, and Tls12. Defaults to Tls12."
  type        = string

  validation {
    condition     = contains(["Tls", "Tls11", "Tls12"], var.minimal_tls_version)
    error_message = "Invalid value. Possible values: 'Tls', 'Tls11', 'Tls12'."
  }
}

variable "offer_type" {
  description = "(Required) Specifies the Offer Type to use for this CosmosDB Account; currently, this can only be set to Standard."
  type        = string

  validation {
    condition     = contains(["Standard"], var.offer_type)
    error_message = "Invalid value. Possible values: 'Standard'."
  }
}

variable "analytical_storage" {
  description = "(Optional) An analytical_storage block as defined below."
  type = object({
    schema_type = string
  })
  nullable = true
}

variable "capacity" {
  description = <<EOT
    total_throughput_limit : (Required) The total throughput limit imposed on this Cosmos DB account (RU/s). Possible values are at least -1. -1 means no limit.
  EOT
  type = object({
    total_throughput_limit = number
  })
  nullable = true
}

variable "create_mode" {
  description = "(Optional) The creation mode for the CosmosDB Account. Possible values are Default and Restore. Changing this forces a new resource to be created."
  type        = string
  nullable    = true

  validation {
    condition     = var.backup.type != "Continous"
    error_message = "create_mode can only be defined when the backup.type is set to Continuous."
  }
}

variable "default_identity_type" {
  description = "(Optional) The default identity for accessing Key Vault. Possible values are FirstPartyIdentity, SystemAssignedIdentity or UserAssignedIdentity. Defaults to FirstPartyIdentity."
  type        = string
  nullable    = true
  default     = "FirstPartyIdentity"

  validation {
    condition     = contains(["FirstPartyIdentity", "SystemAssignedIdentity", "UserAssignedIdentity"], var.default_identity_type)
    error_message = "Invalid value. Possible values: FirstPartyIdentity, SystemAssignedIdentity, UserAssignedIdentity"
  }
}

variable "kind" {
  description = "(Optional) Specifies the Kind of CosmosDB to create - possible values are GlobalDocumentDB, MongoDB and Parse. Defaults to GlobalDocumentDB. Changing this forces a new resource to be created."
  type        = string
  default     = "GlobalDocumentDB"

  validation {
    condition     = contains(["GlobalDocumentDB", "MongoDB", "Parse"], var.kind)
    error_message = "Invalid values. Possible values: GlobalDocumentDB, MongoDB, Parse."
  }
}

variable "consistency_policy" {
  description = "(Required) Specifies one consistency_policy block as defined below, used to define the consistency policy for this CosmosDB account."
  type = object({
    consistency_level       = string
    max_interval_in_seconds = number
    max_staleness_prefix    = number
  })
  nullable = false
}

variable "geo_location" {
  description = "(Required) Specifies one consistency_policy block as defined below, used to define the consistency policy for this CosmosDB account."
  type = object({
    location          = string
    failover_priority = number
    zone_redundant    = bool
  })
  nullable = false
}

variable "ip_range_filter" {
  description = "A set of IP addresses or IP address ranges in CIDR form to be included as the allowed list of client IPs for a given database account. For example [\"55.0.1.0/24\", \"55.0.2.0/24\"]"
  type        = set(string)
  nullable    = true
}

variable "free_tier_enabled" {
  description = "(Optional) Enable the Free Tier pricing option for this Cosmos DB account. Defaults to false. Changing this forces a new resource to be created."
  type        = bool
  default     = false
}

variable "analytical_storage_enabled" {
  description = "(Optional) Enable Analytical Storage option for this Cosmos DB account. Defaults to false. Enabling and then disabling analytical storage forces a new resource to be created."
  type        = bool
  default     = false
}

variable "automatic_failover_enabled" {
  description = "(Optional) Enable Analytical Storage option for this Cosmos DB account. Defaults to false. Enabling and then disabling analytical storage forces a new resource to be created."
  type        = bool
  default     = false
}

variable "partition_merge_enabled" {
  description = "(Optional) Is partition merge on the Cosmos DB account enabled? Defaults to false."
  type        = bool
  default     = false
}

variable "burst_capacity_enabled" {
  description = "(Optional) Enable burst capacity for this Cosmos DB account. Defaults to false."
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether or not public network access is allowed for this CosmosDB account. Defaults to true."
  type        = bool
  default     = true
}

variable "capabilities" {
  description = <<EOT
  "(Optional) The capabilities which should be enabled for this Cosmos DB account. Value is a capabilities block as defined below.
  name : (Required) The capability to enable - Possible values are AllowSelfServeUpgradeToMongo36, DisableRateLimitingResponses, EnableAggregationPipeline, EnableCassandra, EnableGremlin, EnableMongo, EnableMongo16MBDocumentSupport, EnableMongoRetryableWrites, EnableMongoRoleBasedAccessControl, EnableNoSQLVectorSearch, EnablePartialUniqueIndex, EnableServerless, EnableTable, EnableTtlOnCustomPath, EnableUniqueCompoundNestedDocs, MongoDBv3.4 and mongoEnableDocLevelTTL."
  EOT
  type = object({
    name = string
  })
  nullable = true
}

variable "is_virtual_network_filter_enabled" {
  description = "(Optional) Enables virtual network filtering for this Cosmos DB account."
  type        = bool
  nullable    = true
}

variable "key_vault_key_id" {
  description = "(Optional) A versionless Key Vault Key ID for CMK encryption. Changing this forces a new resource to be created."
  type        = string
  nullable    = true
}

variable "virtual_network_rules" {
  description = "(Optional) Specifies a virtual_network_rule block as defined below, used to define which subnets are allowed to access this CosmosDB account."
  type = list(object({
    id                                   = string
    ignore_missing_vnet_service_endpoint = optional(bool)
  }))
  default = null
}

variable "multiple_write_locations_enabled" {
  description = "(Optional) Enable multiple write locations for this Cosmos DB account."
  type        = bool
  nullable    = true
}

variable "access_key_metadata_writes_enabled" {
  description = "(Optional) Is write operations on metadata resources (databases, containers, throughput) via account keys enabled? Defaults to true."
  type        = bool
  default     = true
}

variable "mongo_server_version" {
  description = "(Optional) The Server Version of a MongoDB account. Possible values are 7.0, 6.0, 5.0, 4.2, 4.0, 3.6, and 3.2."
  type        = string
  nullable    = true

  validation {
    condition     = contains(["7.0", "6.0", "5.0", "4.2", "4.0", "3.6", "3.2"], var.mongo_server_version)
    error_message = "Invalid value. Possible values: 7.0, 6.0, 5.0, 4.2, 4.0, 3.6, 3.2"
  }
}

variable "network_acl_bypass_for_azure_services" {
  description = "(Optional) If Azure services can bypass ACLs. Defaults to false."
  type        = bool
  default     = false
}

variable "network_acl_bypass_ids" {
  description = "(Optional) The list of resource Ids for Network Acl Bypass for this Cosmos DB account."
  type        = set(string)
  nullable    = true
}

variable "local_authentication_disabled" {
  description = "(Optional) Disable local authentication and ensure only MSI and AAD can be used exclusively for authentication. Defaults to false. Can be set only when using the SQL API."
  type        = bool
  default     = false
}

variable "backup" {
  description = <<EOT
    backup = {
      tier : (Optional) The continuous backup tier. Possible values are Continuous7Days and Continuous30Days.
      interval_in_minutes : (Optional) The interval in minutes between two backups. Possible values are between 60 and 1440. Defaults to 240.
      retention_in_hours : (Optional) The time in hours that each backup is retained. Possible values are between 8 and 720. Defaults to 8.
      storage_redundancy : (Optional) The storage redundancy is used to indicate the type of backup residency. Possible values are Geo, Local and Zone. Defaults to Geo.
    }
  EOT
  type = object({
    type                = string
    tier                = optional(string)
    interval_in_minutes = optional(number)
    retention_in_hours  = optional(number)
    storage_redundancy  = optional(string)
  })
  nullable = true
}

variable "cors" {
  description = <<EOT
    cors = {
      allowed_headers : (Required) A list of headers that are allowed to be a part of the cross-origin request.
      allowed_methods : (Required) A list of HTTP headers that are allowed to be executed by the origin. Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT or PATCH.
      allowed_origins : (Required) A list of origin domains that will be allowed by CORS.
      exposed_headers : (Required) A list of response headers that are exposed to CORS clients.
      max_age_in_seconds : (Optional) The number of seconds the client should cache a preflight response. Possible values are between 1 and 2147483647.
    }
  EOT
  type = object({
    allowed_headers    = set(string)
    allowed_methods    = set(string)
    allowed_origins    = set(string)
    exposed_headers    = set(string)
    max_age_in_seconds = optional(number)
  })
  nullable = true
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(set(string))
  })
  nullable = true
}

variable "restore" {
  type = object({
    source_cosmosdb_account_id = string
    restore_timestamp_in_utc   = string
    database = optional(object({
      name             = string
      collection_names = optional(set(string))
    }))
    gremlin_database = optional(object({
      name        = string
      graph_names = optional(set(string))
    }))
    tables_to_restore = optional(set(string))
  })
  nullable = true
}
