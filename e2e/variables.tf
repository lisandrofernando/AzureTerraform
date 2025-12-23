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
  type        = string
  default     = "terraformli2025"
}

variable "tags" {
  type = map(string)
  default = {
    environment = "Dev"
    project     = "TerraformDemo"
  }
}

variable "subscription_id" {
  type    = string
  default = "0b3ba0f9-1c7c-466f-b99a-0bee97aaefeb"
}

variable "virtual_network_name" {
  type    = string
  default = "terraform-vnet"
}

variable "virtual_network_address" {
  type    = list(string)
  default = ["10.0.0.0/24"]
}

variable "subnet_name" {
  type    = string
  default = "terraform-subnet"
}

variable "subnet_address" {
  type    = list(string)
  default = ["10.0.0.0/24"]
}

variable "public_ip_name" {
  type    = string
  default = "terraform-public-ip"
}

variable "network_security_group_name" {
  type    = string
  default = "terraform-nsg"
}

variable "network_interface_name" {
  type    = string
  default = "terraform-nic"
}
variable "vm_name" {
  type    = string
  default = "terraform-vm"
}

variable "vm_size" {
  type    = string
  default = "Standard_D2s_v3"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}
variable "admin_password" {
  type = string
}