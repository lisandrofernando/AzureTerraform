variable "resource_group_name" {
  description = "The name of resource group"
  type        = string

}

variable "location" {
  description = "Location"
  type        = string

}


variable "storage_account_name" {
  description = "Storage Account Name"
  type        = string

}

variable "tags" {
  type = map(string)

}

variable "virtual_network_name" {
  type = string

}

variable "virtual_network_address" {
  type = list(string)

}

variable "subnet_name" {
  type = string

}

variable "subnet_address" {
  type = list(string)

}

variable "public_ip_name" {
  type = string

}

variable "network_security_group_name" {
  type = string

}

variable "network_interface_name" {
  type = string

}
variable "vm_name" {
  type = string

}

variable "vm_size" {
  type = string

}

variable "admin_username" {
  type = string

}

variable "admin_password" {
  description = "Admin password for the virtual machine"
  type        = string
  sensitive   = true
}

variable "client_id" {
  description = "Azure service principal client ID"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Azure service principal client secret"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}
