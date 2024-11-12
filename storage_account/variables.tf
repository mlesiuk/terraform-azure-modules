variable "name" {
  description = "(Required) Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the storage account. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
}

variable "account_kind" {
  description = "(Optional) Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Defaults to StorageV2."
  type        = string
  default     = "StorageV2"

  validation {
    condition = contains(["BlobStorage", "BlockBlobStorage", "FileStorage", "Storage", "StorageV2"], var.account_kind)
    error_message = "Invalid values. Possible values: 'BlobStorage', 'BlockBlobStorage', 'FileStorage', 'Storage', 'StorageV2'."
  }
}

variable "account_tier" {
  description = "(Required) Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Changing this forces a new resource to be created."
  type = string

  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "Invalid account_tier option. Valid options: 'Standard', 'Premium'."
  }
}

variable "account_replication_type" {
  description = "(Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. Changing this forces a new resource to be created when types LRS, GRS and RAGRS are changed to ZRS, GZRS or RAGZRS and vice versa."
  type        = string

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "Invalid account_replication_type parameter. Valid options: 'LRS', 'GRS', 'RAGRS', 'ZRS', 'GZRS', 'RAGZRS'."
  }
}

variable "cross_tenant_replication_enabled" {
  description = "(Optional) Should cross Tenant replication be enabled? Defaults to false."
  type        = bool
  default     = false
}

variable "access_tier" {
  description = "(Optional) Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot."
  type    = string
  default = "Hot"

  validation {
    condition = contains(["Hot", "Cool"])
    error_message = "Invalid values. Possible values: 'Hot', 'Cool'."
  }
}

variable "edge_zone" {
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Storage Account should exist. Changing this forces a new Storage Account to be created."
  type        = string
  default     = null
}

variable "https_traffic_only_enabled" {
  description = "(Optional) Boolean flag which forces HTTPS if enabled, see here for more information. Defaults to true."
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "(Optional) The minimum supported TLS version for the storage account. Possible values are TLS1_0, TLS1_1, and TLS1_2. Defaults to TLS1_2 for new storage accounts."
  type        = string
  default     = "TLS1_2"

  validation {
    condition = contains(["TLS1_0", "TLS1_1", "TLS1_2"], var.min_tls_version)
    error_message = "Invalid values. Possible values: 'TLS1_0', 'TLS1_1', 'TLS1_2'."
  }
}

variable "allow_nested_items_to_be_public" {
  description = "(Optional) Allow or disallow nested items within this Account to opt into being public. Defaults to true."
  type        = bool
  default     = true
}

variable "shared_access_key_enabled" {
  description = "(Optional) Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). Defaults to true."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether the public network access is enabled? Defaults to true."
  type        = bool
  default     = true
}

variable "default_to_oauth_authentication" {
  description = "(Optional) Default to Azure Active Directory authorization in the Azure portal when accessing the Storage Account. The default value is false"
  type        = bool
  default     = false
}

variable "is_hns_enabled" {
  description = "(Optional) Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2 (see here for more information). Changing this forces a new resource to be created."
  type        = bool
  default     = false

  validation {
    condition     = var.account_tier == "Standard" || (var.account_tier == "Premium" && var.account_kind == "BlockBlobStorage")
    error_message = "Parameter is_hns_enabled can only be true when account_tier is Standard or when account_tier is Premium and account_kind is BlockBlobStorage"
  }
}

variable "nfsv3_enabled" {
  description = "(Optional) Is NFSv3 protocol enabled? Changing this forces a new resource to be created. Defaults to false."
  type        = bool
  default     = false
}

variable "custom_domain" {
  type = object({
    name          = string
    use_subdomain = optional(bool)
  })
  description = "(Optional) A custom_domain block:\nname - (Required) The Custom Domain Name to use for the Storage Account, which will be validated by Azure.\nuse_subdomain - (Optional) Should the Custom Domain Name be validated by using indirect CNAME validation?"
  default     = null
}

variable "customer_managed_key" {
  type = optional(object({
    key_vault_key_id          = optional(string)
    managed_hsm_key_id        = optional(string)
    user_assigned_identity_id = string
  }))
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(set(string))
  })
  description = "(Optional) An identity block:\ntype - (Required) Specifies the type of Managed Service Identity that should be configured on this Storage Account. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both).\nidentity_ids - (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Storage Account."
  default     = null

  validation {
    condition     = var.identity.type == null
    error_message = "Parameter 'type' is required."
  }

  validation {
    condition     = contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.identity.type)
    error_message = "Parameter 'type' is required."
  }
}

variable "blob_properties" {
  description = <<EOT
    network_acls = {
      bypass : "(Required) Specifies which traffic can bypass the network rules. Possible values are AzureServices and None."
      default_action : "(Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny."
      ip_rules : "(Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault."
      virtual_network_subnet_ids : "(Optional) One or more Subnet IDs which should be able to access this Key Vault."
    }
  EOT
  type = object({
    cors_rule = optional(object({
      allowed_headers = set(string)
    }))
    delete_retention_policy = optional(object({
      days = number
    }))
    resore_policy = optional([

    ])
    versioning_enabled = optional(bool)
    change_feed_enabled = optional(bool)
    change_feed_retention_in_days = optional(number)
    default_service_version =optional(string)
    last_access_time_enabled = optional(bool)
    container_delete_retention_policy = optional(object({
      days = number
    }))
  })
  default = {
    container_delete_retention_policy = {
      days = 7
    }
    delete_retention_policy = {
      days = 7
    }
  }
}

variable "queue_properties" {
  type = object({
    container_delete_retention_policy = optional(object({
      days = number
    }))
    delete_retention_policy = optional(object({
      days = number
    }))
  })
  default = {
    container_delete_retention_policy = {
      days = 7
    }
    delete_retention_policy = {
      days = 7
    }
  }
}

variable "static_website" {
  type = object({
    name = ""
  })

  validation {
    condition     = var.account_kind == "StorageV2" || var.account_kind == "BlockBlobStorage"
    error_message = "static_website can only be set when the account_kind is set to StorageV2 or BlockBlobStorage."
  }
}

variable "share_properties" {
  type = object({
    name = ""
  })

  validation {
    condition     = (var.access_tier == "Standard" && contains(["Storage", "StorageV2"], var.account_kind)) || (var.access_tier == "Premium" && var.account_kind == "FileStorage")
    error_message = "share_properties can only be configured when either account_tier is Standard and account_kind is either Storage or StorageV2 - or when account_tier is Premium and account_kind is FileStorage."
  }
}

variable "network_rules" {
  type = object({
    bypass                     = optional(set(string))
    default_action             = optional(string)
    ip_rules                   = optional(set(string))
    virtual_network_subnet_ids = optional(set(string))
  })
  default = null
}

variable "large_file_share_enabled" {
  type    = bool
  default = false
}

variable "local_user_enabled" {
  description = "(Optional) Is Local User Enabled? Defaults to true."
  type        = bool
  default     = true
}

variable "azure_files_authentication" {
  type = object({
    name = ""
  })
}

variable "routing" {
  type = object({
    name = ""
  })
}

variable "queue_encryption_key_type" {
  description = "(Optional) The encryption type of the queue service. Possible values are Service and Account. Changing this forces a new resource to be created. Default value is Service."
  type        = string
  default     = "Service"

  validation {
    condition     = var.account_kind != "Storage"
    error_message = "queue_encryption_key_type cannot be set to Account when account_kind is set Storage"
  }

  validation {
    condition     = contains(["Service", "Account"], var.queue_encryption_key_type)
    error_message = "Invalid value. Possible values: 'Service', 'Account'."
  }
}

variable "table_encryption_key_type" {
  description = "(Optional) The encryption type of the table service. Possible values are Service and Account. Changing this forces a new resource to be created. Default value is Service."
  type        = string
  default     = "Service"

  validation {
    condition     = var.account_kind != "Storage"
    error_message = "table_encryption_key_type cannot be set to Account when account_kind is set Storage"
  }

  validation {
    condition     = contains(["Service", "Account"], var.queue_encryption_key_type)
    error_message = "Invalid value. Possible values: 'Service', 'Account'."
  }
}

variable "infrastructure_encryption_enabled" {
  description = "(Optional) Is infrastructure encryption enabled? Changing this forces a new resource to be created. Defaults to false."
  type        = bool
  default     = false
}

variable "sas_policy" {
  type = object({
    expiration_action = optional(string)
    expiration_period = optional(string)
  })
  default = null
}

variable "allowed_copy_scope" {
  description = "(Optional) Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet. Possible values are AAD and PrivateLink."
  type        = string
  nullable    = true

  validation {
    condition     = contains(["AAD", "PrivateLink"], var.allowed_copy_scope)
    error_message = "Invalid value. Possible values: 'AAD', 'PrivateLink'."
  }
}

variable "sftp_enabled" {
  description = "(Optional) Boolean, enable SFTP for the storage account."
  type        = bool
  nullable    = true

  validation {
    condition     = var.is_hns_enabled == true
    error_message = "SFTP support requires is_hns_enabled set to true."
  }
}

variable "dns_endpoint_type" {
  description = "(Optional) Specifies which DNS endpoint type to use. Possible values are Standard and AzureDnsZone. Defaults to Standard. Changing this forces a new resource to be created."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "AzureDnsZone"], var.dns_endpoint_type)
    error_message = "Invalid value. Possible values: 'Standard', 'AzureDnsZone'."
  }
}

variable "tags" {
  type = map(string)
}
