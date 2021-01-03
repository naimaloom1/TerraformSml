resource "azurerm_virtual_network" "sgirm" {
  name                = "${var.prefix}_vnet_${var.deployment_region}_${var.environment}"
  resource_group_name = azurerm_resource_group.sgirm.name
  location            = azurerm_resource_group.sgirm.location
  address_space       = var.vnet_cidr_range
}
resource "azurerm_subnet" "subsql" {
  name                 = "${var.prefix}_sqlsubnet_${var.deployment_region}_${var.environment}"
  resource_group_name  = azurerm_resource_group.sgirm.name
  virtual_network_name = azurerm_virtual_network.sgirm.name
  address_prefixes     = var.subsql_prefix
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_storage_account" "sgirm" {
  name                     = "${var.prefix}storage${var.deployment_region}${var.environment}"
  resource_group_name      = azurerm_resource_group.sgirm.name
  location                 = azurerm_resource_group.sgirm.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_sql_server" "sgirm" {
  name                         = "${var.prefix}-sqlserver-${var.deployment_region}-${var.environment}"
  resource_group_name          = azurerm_resource_group.sgirm.name
  location                     = azurerm_resource_group.sgirm.location
  version                      = "12.0"
  administrator_login          = "binfhil"
  administrator_login_password = "akiskid@123"

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.sgirm.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.sgirm.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }
}
resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {
  name                = "${var.prefix}-vnetrule-${var.deployment_region}-${var.environment}"
  resource_group_name = azurerm_resource_group.sgirm.name
  server_name         = azurerm_sql_server.sgirm.name
  subnet_id           = azurerm_subnet.subsql.id
}
resource "azurerm_network_security_group" "nsgsql" {
  name                = "${var.prefix}-nsg2-${var.deployment_region}-${var.environment}"
  location            = azurerm_resource_group.sgirm.location
  resource_group_name = azurerm_resource_group.sgirm.name

security_rule {   //Here opened remote desktop port
    name                       = "RDP"  
    priority                   = 110  
    direction                  = "Inbound"  
    access                     = "Allow" 
    protocol                   = "Tcp"  
    source_port_range          = "*"  
    destination_port_range     = "3389"  
    source_address_prefix      = "*"  
    destination_address_prefix = "*"  
  }
}
resource "azurerm_subnet_network_security_group_association" "subsql" {
  subnet_id                 = azurerm_subnet.subsql.id
  network_security_group_id = azurerm_network_security_group.nsgsql.id
}
resource "azurerm_sql_database" "sgirm" {
  name                = "${var.prefix}-sqldb-${var.deployment_region}-${var.environment}"
  resource_group_name = azurerm_resource_group.sgirm.name
  location            = azurerm_resource_group.sgirm.location
  server_name         = azurerm_sql_server.sgirm.name

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.sgirm.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.sgirm.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }
}