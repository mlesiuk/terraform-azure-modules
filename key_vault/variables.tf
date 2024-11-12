variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Key Vault. Changing this forces a new resource to be created. The name must be globally unique. If the vault is in a recoverable state then the vault will need to be purged before reusing the name."
  nullable    = false
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  nullable    = false
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Key Vault. Changing this forces a new resource to be created."
  nullable    = false
}

variable "sku_name" {
  type        = string
  description = "(Required) The Name of the SKU used for this Key Vault. Possible values are standard and premium."
  nullable    = false

  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "Invalid value. Possible values are standard and premium."
  }
}

variable "tenant_id" {
  type        = string
  description = "(Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault."
  nullable    = false
}

variable "access_policy" {
  type = list(object({
    tenant_id               = string
    object_id               = string
    application_id          = optional(string)
    certificate_permissions = optional(list(string))
    key_permissions         = optional(list(string))
    secret_permissions      = optional(list(string))
    storage_permissions     = optional(list(string))
  }))
  description = <<EOT
    access_policy = {
      tenant_id : "(Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. Must match the tenant_id used above."
      object_id : "(Required) The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies."
      application_id : "(Optional) The object ID of an Application in Azure Active Directory."
      certificate_permissions : "(Optional) List of certificate permissions, must be one or more from the following: Backup, Create, Delete, DeleteIssuers, Get, GetIssuers, Import, List, ListIssuers, ManageContacts, ManageIssuers, Purge, Recover, Restore, SetIssuers and Update."
      key_permissions : "(Optional) List of key permissions. Possible values are Backup, Create, Decrypt, Delete, Encrypt, Get, Import, List, Purge, Recover, Restore, Sign, UnwrapKey, Update, Verify, WrapKey, Release, Rotate, GetRotationPolicy and SetRotationPolicy."
      secret_permissions : "(Optional) List of secret permissions, must be one or more from the following: Backup, Delete, Get, List, Purge, Recover, Restore and Set."
      storage_permissions : "(Optional) List of storage permissions, must be one or more from the following: Backup, Delete, DeleteSAS, Get, GetSAS, List, ListSAS, Purge, Recover, RegenerateKey, Restore, Set, SetSAS and Update."
    }
  EOT
}

variable "enabled_for_deployment" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault."
  default     = null
}

variable "enabled_for_disk_encryption" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  default     = null
}

variable "enabled_for_template_deployment" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault."
  default     = null
}

variable "enable_rbac_authorization" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions."
  default     = null
}

variable "network_acls" {
  type = object({
    bypass                     = string
    default_action             = string
    ip_rules                   = optional(set(string))
    virtual_network_subnet_ids = optional(set(string))
  })
  description = <<EOT
    network_acls = {
      bypass : "(Required) Specifies which traffic can bypass the network rules. Possible values are AzureServices and None."
      default_action : "(Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny."
      ip_rules : "(Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault."
      virtual_network_subnet_ids : "(Optional) One or more Subnet IDs which should be able to access this Key Vault."
    }
  EOT
}

variable "purge_protection_enabled" {
  type        = bool
  description = "(Optional) Is Purge Protection enabled for this Key Vault?"
  default     = null
}

variable "public_network_access_enabled" {
  type        = bool
  description = "(Optional) Whether public network access is allowed for this Key Vault. Defaults to true."
  default     = true
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Optional) The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days."

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "Invalid parameter value. Value can be between 7 and 90 (the default) days."
  }
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}
