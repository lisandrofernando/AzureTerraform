resource_group_name  = "dev-rg"
location             = "eastus"
storage_account_name = "devlesa2025"
tags = {
  environment = "dev"
  project     = "terraform-dev-demo"
}
virtual_network_name        = "dev-vnet"
virtual_network_address     = ["10.0.0.0/24"]
subnet_name                 = "dev-snet"
subnet_address              = ["10.0.0.0/24"]
public_ip_name              = "dev-pip"
network_security_group_name = "dev-nsg"
network_interface_name      = "dev-nic"
vm_name                     = "dev-vm"
vm_size                     = "Standard_D2s_v3"
admin_username              = "azureuser"
admin_password              = "P@ssw0rd123!"
