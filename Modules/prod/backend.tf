# Azure terraform backend configuration
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-rg"
    storage_account_name = "terrfaformsate"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}