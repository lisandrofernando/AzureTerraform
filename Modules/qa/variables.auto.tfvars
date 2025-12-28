resource_group_name  = "qa-rg"
location             = "eastus"
storage_account_name = "qastorageleo2025"
tags = {
  environment = "qa"
  project     = "terraform"
}
virtual_network_name        = "qa-vnet"
virtual_network_address     = ["10.0.2.0/24"]
subnet_name                 = "qa-subnet"
subnet_address              = ["10.0.2.0/24"]
public_ip_name              = "qa-public-ip"
network_security_group_name = "qa-nsg"
network_interface_name      = "qa-nic"
vm_name                     = "qa-vm"
vm_size                     = "Standard_D2s_v3"
admin_username              = "azureuser"
admin_password              = "P@ssw0rd123!"