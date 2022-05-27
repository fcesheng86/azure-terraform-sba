resource "azurerm_linux_virtual_machine_scale_set" "apiserver_vmss" {
  depends_on = [
    azurerm_postgresql_flexible_server.postgres_db
  ]
  name                            = "api-vmss"
  resource_group_name             = azurerm_resource_group.example.name
  location                        = azurerm_resource_group.example.location
  sku                             = "Standard_D2ads_v5"
  instances                       = 1
  admin_username                  = "nicAZ"
  disable_password_authentication = false
  admin_password                  = "Jupiternic1234"

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "vmss_network_interface"
    primary = true

    ip_configuration {
      name      = "api_ip_config"
      primary   = true
      subnet_id = azurerm_subnet.api_subnet_pvt.id
    }

    network_security_group_id = azurerm_network_security_group.Jupiter_SG.id
  }

  custom_data = filebase64("az_apiserver2.sh")

  tags = {
    "Name"      = "apiserver-vmss"
    "Terraform" = true
  }
}

resource "azurerm_linux_virtual_machine_scale_set" "frontend_vmss" {
  depends_on = [
    azurerm_lb.api_lb
  ]
  name                            = "frontend-vmss"
  resource_group_name             = azurerm_resource_group.example.name
  location                        = azurerm_resource_group.example.location
  sku                             = "Standard_D2ads_v5"
  instances                       = 1
  admin_username                  = "nicAZ"
  disable_password_authentication = false
  admin_password                  = "Jupiternic1234"

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "frontend_vmss_network_interface"
    primary = true

    ip_configuration {
      name      = "frontend_ip_config"
      primary   = true
      subnet_id = azurerm_subnet.frontend_subnet_pvt.id
    }

    network_security_group_id = azurerm_network_security_group.Jupiter_SG.id
  }

  custom_data = filebase64("frontend3.sh")

  tags = {
    "Name"      = "frontend-vmss"
    "Terraform" = true
  }
}

