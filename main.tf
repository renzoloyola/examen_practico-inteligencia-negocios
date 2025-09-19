# 1. Configura el proveedor de Azure
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 2. Crea un grupo de recursos (un contenedor para tus servicios)
resource "azurerm_resource_group" "rg" {
  name     = "rg-globaljobs-practice"
  location = "East US" # Puedes elegir una región cercana a ti
}

# 3. Crea el servidor de PostgreSQL Flexible Server
# Usamos una versión económica (Burstable) ideal para desarrollo y pruebas
resource "azurerm_postgresql_flexible_server" "psql_server" {
  name                   = "psql-globaljobs-server"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  version                = "14"
  delegated_subnet_id    = null
  private_dns_zone_id    = null
  administrator_login    = "psqladmin"
  administrator_password = "tuContrasenaSegura123!" # 🔑 ¡Cámbiala por una tuya!
  zone                   = "1"
  storage_mb             = 32768 # 32 GB

  sku_name = "B_Standard_B1ms" # SKU de bajo costo

  # Desactiva el backup para ahorrar costos en esta práctica
  backup_retention_days = 7 
}

# 4. Crea una regla en el firewall para permitir acceso desde Internet
# ⚠️ ¡Importante! Esto permite acceso desde cualquier IP, solo para la práctica.
resource "azurerm_postgresql_flexible_server_firewall_rule" "firewall_rule" {
  name             = "AllowAllIPs"
  server_id        = azurerm_postgresql_flexible_server.psql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}