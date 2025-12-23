

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
  default = "terraformKeyVaultDemo"
}

variable "tenant_id" {
  type    = string
  default = "72f988bf-86f1-41af-91ab-2d7cd011db47"
}

variable "subscription_id" {
  description = "Azure subscription id."
  type        = string
  default     = ""
}