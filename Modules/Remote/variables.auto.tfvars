resource_group_name  = "remote-rg"
location             = "eastus"
storage_account_name = "remotelesa2025"
tags = {
  environment = "remote"
  project     = "terraform-remote-demo"
}
virtual_network_name        = "remote-vnet"
virtual_network_address     = ["10.0.0.0/24"]
subnet_name                 = "remote-snet"
subnet_address              = ["10.0.0.0/24"]
public_ip_name              = "remote-pip"
network_security_group_name = "remote-nsg"
network_interface_name      = "remote-nic"
vm_name                     = "remote-vm"
vm_size                     = "Standard_D2s_v3"
admin_username              = "azureuser"
admin_password              = "P@ssw0rd123!"
