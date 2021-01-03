resource "azurerm_data_factory" "sgirm" {
  name                = "${var.prefix}-datafactory-${var.deployment_region}-${var.environment}"
  location            = azurerm_resource_group.sgirm.location
  resource_group_name = azurerm_resource_group.sgirm.name
}
