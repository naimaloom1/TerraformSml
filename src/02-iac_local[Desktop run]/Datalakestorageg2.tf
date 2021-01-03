resource "azurerm_storage_account" "adlsg2" {
  name                     = "${var.prefix}adls${var.deployment_region}${var.environment}"
  resource_group_name      = azurerm_resource_group.sgirm.name
  location                 = azurerm_resource_group.sgirm.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "sgirm" {
  name               = "${var.prefix}adls${var.deployment_region}${var.environment}"
  storage_account_id = azurerm_storage_account.adlsg2.id
}