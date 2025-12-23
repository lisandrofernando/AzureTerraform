module "prod-vm" {
  source = "../"

  resource_group_name         = var.resource_group_name
  location                    = var.location
  storage_account_name        = var.storage_account_name
  tags                        = var.tags
  virtual_network_name        = var.virtual_network_name
  virtual_network_address     = var.virtual_network_address
  subnet_name                 = var.subnet_name
  subnet_address              = var.subnet_address
  public_ip_name              = var.public_ip_name
  network_security_group_name = var.network_security_group_name
  network_interface_name      = var.network_interface_name
  vm_name                     = var.vm_name
  vm_size                     = var.vm_size
  admin_username              = var.admin_username
  admin_password              = var.admin_password
}