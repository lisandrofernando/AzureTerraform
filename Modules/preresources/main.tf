
# create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}
# create a storage account
resource "azurerm_storage_account" "sa" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = var.tags
}

# create a container in the storage account
resource "azurerm_storage_container" "container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

# Use current authenticated tenant
data "azurerm_client_config" "current" {}

# create a key vault
resource "azurerm_key_vault" "kv" {
  name                            = var.key_vault_name
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  sku_name                        = "standard"
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = 7
  purge_protection_enabled        = false
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  tags                            = var.tags
}

# Key Vault access policy for service principal (created only when service_principal_object_id is provided)
resource "azurerm_key_vault_access_policy" "sp_kv_policy" {
  count        = var.service_principal_object_id == "" ? 0 : 1
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.service_principal_object_id

  key_permissions = [
    "Get",
    "List",
    "Create",
    "Update",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Encrypt",
    "Decrypt"
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Backup",
    "Restore"
  ]

  certificate_permissions = [
    "Get",
    "List",
    "Create",
    "Delete",
    "ManageContacts",
    "GetIssuers",
    "ListIssuers"
  ]

  depends_on = [azurerm_key_vault.kv]
}

# Assign role to service principal on the resource group (created only when object id is provided)
resource "azurerm_role_assignment" "sp_rg_role" {
  count                = var.service_principal_object_id == "" ? 0 : 1
  scope                = azurerm_resource_group.rg.id
  role_definition_name = var.service_principal_role
  principal_id         = var.service_principal_object_id
  depends_on           = [azurerm_resource_group.rg]
}

# Optionally assign a subscription-scoped role to the service principal
resource "azurerm_role_assignment" "sp_subscription_role" {
  count                = var.service_principal_object_id == "" || var.assign_role_subscription == false ? 0 : 1
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = var.service_principal_role
  principal_id         = var.service_principal_object_id
  depends_on           = [azurerm_resource_group.rg]
}

