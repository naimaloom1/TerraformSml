resource "azurerm_key_vault" "sgirm" {
  name                     = "${var.prefix}-vault-${var.deployment_region}-${var.environment}"
  location                 = azurerm_resource_group.sgirm.location
  resource_group_name      = azurerm_resource_group.sgirm.name
  tenant_id                = var.azurerm_client_config_current_tenant_id
  soft_delete_enabled      = true
  purge_protection_enabled = false
  sku_name                 = "premium"

  access_policy {
    tenant_id = var.azurerm_client_config_current_tenant_id
    object_id = var.azurerm_client_config_current_object_id
       key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "set",
      "get",
      "delete",
    ]
  }
}