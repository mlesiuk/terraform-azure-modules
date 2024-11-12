variable "name" {
  type        = string
  description = "(Required) The name of the Redis instance. Changing this forces a new resource to be created."

  validation {
    condition     = length(var.name) > 0
    error_message = "The Redis Cache instance name cannot be empty."
  }

  validation {
    condition     = length(var.name) <= 63
    error_message = "The Redis Cache instance name length must not exceed 63 characters."
  }
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Redis instance. Changing this forces a new resource to be created."

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "The Redis Cache resource group name cannot be empty."
  }

  validation {
    condition     = length(var.resource_group_name) <= 90
    error_message = "The Redis Cache resource group name length must not exceed 90 characters."
  }
}

variable "location" {
  type        = string
  description = "(Required) The location of the resource group. Changing this forces a new resource to be created."

  validation {
    condition     = length(var.location) > 0
    error_message = "The Redis Cache location cannot be empty."
  }
}

variable "capacity" {
  type        = number
  description = "(Required) The size of the Redis cache to deploy. Valid values for a SKU family of C (Basic/Standard) are 0, 1, 2, 3, 4, 5, 6, and for P (Premium) family are 1, 2, 3, 4, 5."
  default     = 0

  validation {
    condition     = var.family == "C" && (var.capacity >= 0 || var.cache <= 6)
    error_message = "Invalid value of capacity. Valid values for a SKU family of C (Basic/Standard) family are 0, 1, 2, 3, 4, 5, 6."
  }

  validation {
    condition     = var.family == "P" && (var.capacity >= 1 || var.cache <= 5)
    error_message = "Invalid value of capacity. Valid values for a SKU family of P (Premium) family are 1, 2, 3, 4, 5."
  }
}

variable "family" {
  type        = string
  description = "(Required) The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium)."
  nullable    = false

  validation {
    condition     = contains(["C", "P"], var.family)
    error_message = "The SKU family parameter contains invalid value. Possible values: 'C', 'P'."
  }
}

variable "sku_name" {
  type        = string
  description = "(Required) The SKU of Redis to use. Possible values are Basic, Standard and Premium."
  default     = null

  validation {
    condition     = var.sku_name == null || length(var.sku_name) <= 0
    error_message = "The SKU parameter is required."
  }
}

variable "access_keys_authentication_enabled" {
  type        = bool
  description = "(Optional) Whether access key authentication is enabled? Defaults to true. active_directory_authentication_enabled must be set to true to disable access key authentication."
  default     = true
}

variable "non_ssl_port_enabled" {
  type        = bool
  description = "(Optional) Enable the non-SSL port (6379) - disabled by default."
  default     = false
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(set(string))
    description  = "(Required) Specifies the type of Managed Service Identity that should be configured on this Redis Cluster. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both)."
    allowed      = ""
  })
}

variable "minimum_tls_version" {
  type        = string
  description = "(Optional) The minimum TLS version. Possible values are 1.0, 1.1 and 1.2. Defaults to 1.0."
  default     = "1.0"
}

variable "patch_schedules" {
  type = optional(list(object({
    day_of_week        = string
    maintenance_window = string
    start_hour_utc     = number
  })))
  default = [
    {
      day_of_week        = "Sunday"
      maintenance_window = "PT5H"
      start_hour_utc     = 0
    }
  ]
}

variable "private_static_ip_address" {
  type        = string
  description = "(Optional) The Static IP Address to assign to the Redis Cache when hosted inside the Virtual Network. This argument implies the use of subnet_id. Changing this forces a new resource to be created."
  default     = null
}

variable "public_network_access_enabled" {
  type        = bool
  description = "(Optional) Whether or not public network access is allowed for this Redis Cache. true means this resource could be accessed by both public and private endpoint. false means only private endpoint access is allowed. Defaults to true."
  default     = true
}

variable "redis_configuration" {
  type = object({
    maxmemory_reserved              = number
    maxmemory_delta                 = number
    maxfragmentationmemory_reserved = number
    maxmemory_policy                = string
  })
  default = {
    maxmemory_reserved              = 30
    maxmemory_delta                 = 30
    maxfragmentationmemory_reserved = 30
    maxmemory_policy                = "volatile-lru"
  }
}

variable "replicas_per_master" {
  type        = number
  description = "(Optional) Amount of replicas to create per master for this Redis Cache."
  default     = null
}

variable "replicas_per_primary" {
  type        = number
  description = "(Optional) Amount of replicas to create per primary for this Redis Cache. If both replicas_per_primary and replicas_per_master are set, they need to be equal."
  default     = null
}

variable "redis_version" {
  type        = string
  description = "(Optional) Redis version. Only major version needed. Possible values are 4 and 6. Defaults to 6."
  default     = "6"
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}

variable "tenant_settings" {
  type        = map(string)
  description = "(Optional) A mapping of tenant settings to assign to the resource."
  default     = {}
}

variable "shard_count" {
  type        = number
  description = "(Optional) Only available when using the Premium SKU The number of Shards to create on the Redis Cluster."
  default     = null

  validation {
    condition     = var.sku_name != "P"
    error_message = "The subnet_id variable is only available when using the Premium SKU."
  }
}

variable "subnet_id" {
  type        = string
  description = "(Optional) Only available when using the Premium SKU. The ID of the Subnet within which the Redis Cache should be deployed. This Subnet must only contain Azure Cache for Redis instances without any other type of resources. Changing this forces a new resource to be created."
  default     = null

  validation {
    condition     = var.sku_name != "P"
    error_message = "The subnet_id variable is only available when using the Premium SKU."
  }
}

variable "zones" {
  type        = set(string)
  description = "(Optional) Specifies a list of Availability Zones in which this Redis Cache should be located. Changing this forces a new Redis Cache to be created."
  default     = []
}
