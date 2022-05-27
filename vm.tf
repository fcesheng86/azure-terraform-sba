# resource "azurerm_virtual_machine" "frontend" {
#   name                  = "Frontend-VM"
#   location              = azurerm_resource_group.example.location
#   resource_group_name   = azurerm_resource_group.example.name
#   network_interface_ids = [azurerm_network_interface.frontend.id]
#   vm_size               = "Standard_D2ads_v5"

#   # Uncomment this line to delete the OS disk automatically when deleting the VM
#   delete_os_disk_on_termination = true

#   #delete_data_disks_on_termination = true

#   storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }
#   storage_os_disk {
#     name              = "myosdisk1"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#     os_type           = "Linux"
#   }
#   os_profile {
#     computer_name  = "Frontend"
#     admin_username = "nicAZ"
#     admin_password = "Jupiternic1234"
#     custom_data    = filebase64("frontend.sh")
#   }
#   os_profile_linux_config {
#     disable_password_authentication = false

#   }
#   tags = {
#     Environment = "Terraform"
#     Name        = "Frontend"
#   }
# }

# resource "azurerm_virtual_machine" "apiserver" {
#   name                  = "Apiserver-VM"
#   location              = azurerm_resource_group.example.location
#   resource_group_name   = azurerm_resource_group.example.name
#   network_interface_ids = [azurerm_network_interface.apiserver.id]
#   vm_size               = "Standard_D2ads_v5"

#   # Uncomment this line to delete the OS disk automatically when deleting the VM
#   delete_os_disk_on_termination = true

#   #delete_data_disks_on_termination = true

#   storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }
#   storage_os_disk {
#     name              = "myosdisk2"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#     os_type           = "Linux"
#   }
#   os_profile {
#     computer_name  = "ApiServer"
#     admin_username = "nicAZ"
#     admin_password = "Jupiternic1234"
#     custom_data    = filebase64("az_apiserver.sh")
#   }
#   os_profile_linux_config {
#     disable_password_authentication = false

#   }
#   tags = {
#     Environment = "Terraform"
#     Name        = "ApiServer"
#   }
# }

#Bastion Host
resource "azurerm_virtual_machine" "bastionvm" {
  name                  = "Bastion-VM"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.bastion.id]
  vm_size               = "Standard_D2ads_v5"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  #delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk3"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    os_type           = "Linux"
  }
  os_profile {
    computer_name  = "BastionVM"
    admin_username = "nicAZ"
    admin_password = "Jupiternic1234"
  }
  os_profile_linux_config {
    disable_password_authentication = false

  }
  tags = {
    Environment = "Terraform"
    Name        = "BastionVM"
  }
}

