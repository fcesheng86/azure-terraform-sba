resource "azurerm_virtual_network" "main" {
  name                = "Jupiter-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

############### Subnet creation #############################
resource "azurerm_subnet" "app_gateway_subnet" {
  name                 = "app_gateway_subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "api_lb_subnet" {
  name                 = "api_subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "db_subnet" {
  name                 = "db_subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.3.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "bastion_subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.4.0/24"]
}

resource "azurerm_subnet" "api_subnet_pvt" {
  name                 = "api_subnet_pvt"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.5.0/24"]
}

resource "azurerm_subnet" "frontend_subnet_pvt" {
  name                 = "frontend_subnet_pvt"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.6.0/24"]
}

###### public IPs ################
resource "azurerm_public_ip" "app_gateway_ip" {
  name                = "APp_Gateway_IP"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_public_ip" "api_lb_ip" {
  name                = "API_LB_IP"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_public_ip" "bastion_ip" {
  name                = "Bastion_IP"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
    Name        = "Bastion_IP"
  }
}

resource "azurerm_public_ip" "ngw_ip" {
  name                = "ngw_IP_new"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]

  tags = {
    environment = "Production"
    Name        = "NGW_IP"
  }
}

############# Network Interface ###############
# resource "azurerm_network_interface" "frontend" {
#   name                = "Jupiter-Frontend-Network-Interface"
#   location            = "Central US"
#   resource_group_name = azurerm_resource_group.example.name

#   ip_configuration {
#     name                          = "pb-ip-config"
#     subnet_id                     = azurerm_subnet.app_gateway_subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.app_gateway_ip.id
#   }
# }

# resource "azurerm_network_interface" "api_lb" {
#   name                = "Jupiter-Apiserver-Network-Interface"
#   location            = "Central US"
#   resource_group_name = azurerm_resource_group.example.name

#   ip_configuration {
#     name                          = "apiserver-ip-config"
#     subnet_id                     = azurerm_subnet.api_lb_subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.api_lb_ip.id
#   }
# }

resource "azurerm_network_interface" "apiserver_vmss" {
  name                = "Jupiter-Apiserver-VMSS-Network-Interface"
  location            = "Central US"
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "apiserver-vmss-ip-config"
    subnet_id                     = azurerm_subnet.api_subnet_pvt.id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_network_interface" "bastion" {
  name                = "Jupiter-Bastion-Network-Interface"
  location            = "Central US"
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "bastion-ip-config"
    subnet_id                     = azurerm_subnet.bastion_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bastion_ip.id
  }
}
############# NAT Gateway ############################
resource "azurerm_nat_gateway" "ngw_jupiter" {
  name                    = "ngw_jupiter"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}

resource "azurerm_nat_gateway_public_ip_association" "example" {
  nat_gateway_id       = azurerm_nat_gateway.ngw_jupiter.id
  public_ip_address_id = azurerm_public_ip.ngw_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "apiserver" {
  subnet_id      = azurerm_subnet.api_subnet_pvt.id
  nat_gateway_id = azurerm_nat_gateway.ngw_jupiter.id
}

resource "azurerm_subnet_nat_gateway_association" "frontend" {
  subnet_id      = azurerm_subnet.frontend_subnet_pvt.id
  nat_gateway_id = azurerm_nat_gateway.ngw_jupiter.id
}

# #output of apiserver IP. Allocated Dynamically
# data "azurerm_public_ip" "apiserver_ip" {
#   name                = azurerm_public_ip.apiserver_ip.name
#   resource_group_name = azurerm_virtual_machine.apiserver.resource_group_name
# }

# output "apiserver_ip" {
#   value = data.azurerm_public_ip.apiserver_ip.ip_address
# }
