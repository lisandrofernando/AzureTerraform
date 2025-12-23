

variable "resource_group_name" {
  type    = string
  default = "terraform-rg"
}
variable "tags" {
  type = map(string)
  default = {
    environment = "Dev"
    project     = "TerraformDemo"
  }
}
variable "location" {
  type    = string
  default = "eastus"
}
variable "storage_account_name" {
  type    = string
  default = "terrfaformsate"
}

variable "key_vault_name" {
  type    = string
  default = "terraformKeyVaultDemo2"
}

variable "tenant_id" {
  type    = string
  default = ""
}

variable "subscription_id" {
  description = "Azure subscription id."
  type        = string
  default     = "0b3ba0f9-1c7c-466f-b99a-0bee97aaefeb"
}

variable "assign_role_subscription" {
  description = "Whether to create a subscription-scoped role assignment for the service principal (boolean)."
  type        = bool
  default     = false
}

# Service Principal to grant access
variable "service_principal_object_id" {
  description = "The object id of the service principal (Azure AD Object ID). Used for role assignments and Key Vault access policies."
  type        = string
  default     = ""
}

variable "service_principal_app_id" {
  description = "The application (client) id of the service principal. Optional, used by CLI scripts and outputs."
  type        = string
  default     = ""
}

variable "service_principal_role" {
  description = "Role to assign to the service principal on the resource group (e.g., 'Contributor', 'Contributor')"
  type        = string
  default     = "Contributor"
}

variable "assign_kv_permissions" {
  description = "Whether to create a Key Vault access policy for the service principal"
  type        = bool
  default     = true
}

variable "client_id" {
  description = "Service principal (app) client id. Leave empty to use Azure CLI or managed identity."
  type        = string
  default     = ""
}

variable "client_secret" {
  description = "Service principal client secret. Sensitive - do not commit to source control."
  type        = string
  sensitive   = true
  default     = ""
}