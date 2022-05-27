resource "azurerm_private_dns_zone" "example" {
  depends_on = [
    azurerm_subnet.db_subnet
  ]
  name                = "smartbankapp.private.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  name                  = "Jupiter.com"
  private_dns_zone_name = azurerm_private_dns_zone.example.name
  virtual_network_id    = azurerm_virtual_network.main.id
  resource_group_name   = azurerm_resource_group.example.name
}

resource "azurerm_postgresql_flexible_server" "postgres_db" {
  name                   = "smartbankapp"
  resource_group_name    = azurerm_resource_group.example.name
  location               = azurerm_resource_group.example.location
  version                = "13"
  delegated_subnet_id    = azurerm_subnet.db_subnet.id
  private_dns_zone_id    = azurerm_private_dns_zone.example.id
  administrator_login    = "postgres"
  administrator_password = "Jupiter@123"
  zone                   = "1"

  storage_mb = 32768

  sku_name = "B_Standard_B1ms"
  # "B_Standard_B1ms"
  #"GP_Standard_D2s_v3"

  # high_availability {
  #   mode                      = "ZoneRedundant"
  #   standby_availability_zone = "2"
  # }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.example]

}

resource "azurerm_postgresql_flexible_server_database" "smartbankapp" {
  name      = "smartbankapp"
  server_id = azurerm_postgresql_flexible_server.postgres_db.id
  collation = "en_US.utf8"
  charset   = "utf8"
}
