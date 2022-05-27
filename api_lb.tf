resource "azurerm_lb" "api_lb" {
  name                = "API_LB"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"
  sku_tier            = "Regional"

  frontend_ip_configuration {
    name = "API_LB_IP"
    # public_ip_address_id = azurerm_public_ip.api_lb_ip.id
    subnet_id                     = azurerm_subnet.api_lb_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb_backend_address_pool" "example" {
  loadbalancer_id = azurerm_lb.api_lb.id
  name            = "API_LB_BackEndAddressPool"
}

resource "azurerm_lb_rule" "example" {
  loadbalancer_id                = azurerm_lb.api_lb.id
  name                           = "LB_Rule"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "API_LB_IP"
}

resource "azurerm_lb_probe" "example" {
  loadbalancer_id = azurerm_lb.api_lb.id
  name            = "port-8080-probe"
  port            = 8080
}
