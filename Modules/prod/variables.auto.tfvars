resource_group_name  = "prod-rg"
location             = "eastus"
storage_account_name = "prodstorageleo2025"
tags = {
  environment = "prod"
  project     = "terraform"
}
virtual_network_name        = "prod-vnet"
virtual_network_address     = ["10.0.1.0/24"]
subnet_name                 = "prod-subnet"
subnet_address              = ["10.0.1.0/24"]
public_ip_name              = "prod-public-ip"
network_security_group_name = "prod-nsg"
network_interface_name      = "prod-nic"
vm_name                     = "prod-vm"
vm_size                     = "Standard_D2s_v3"
admin_username              = "azureuser"
admin_password              = "P@ssw0rd123!"