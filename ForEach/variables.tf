variable "resource_group_name" {
  description = "The name of resource group"
  type        = string
  default     = "terraform_rg"
}

variable "location" {
  description = "Location"
  type        = string
  default     = "eastus"
}


variable "storage_account_name" {
  description = "Storage Account Name"
  type        = list(string)
}

variable "tags" {
  type = map(string)
  default = {
    environment = "Dev"
    project     = "TerraformDemo"
  }
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

variable "tenant_id" {
  description = "Azure Tenant id. If empty, Azure CLI's tenant will be used."
  type        = string
  default     = ""
}

variable "subscription_id" {
  description = "Azure subscription id."
  type        = string
  default     = ""
}
