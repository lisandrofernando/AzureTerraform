# Use this data source to access information about an existing Resource Group

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# Use this data source to access information about an existing Virtual Network
data "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Use this data source to access information about an existing Subnet
data "azurerm_subnet" "snet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

# Use this data source to access information about an existing Key Vault.
data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Use this data source to access information about an existing Key Vault Secret.
data "azurerm_key_vault_secret" "kv_secret" {
  name         = var.key_vault_secret_name
  key_vault_id = data.azurerm_key_vault.kv.id
}
