resource "azurerm_subnet" "sgirm1" {
  name                 = "${var.prefix}_subnet1_${var.deployment_region}_${var.environment}"
  resource_group_name  = azurerm_resource_group.sgirm.name
  virtual_network_name = azurerm_virtual_network.sgirm.name
  address_prefixes     = var.subnet1_prefix
  delegation {
    name = "sgiapedevdbrdelg"

    service_delegation {
      name    = "Microsoft.Databricks/workspaces"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}
resource "azurerm_subnet" "sgirm" {
  name                 = "${var.prefix}_subnet2_${var.deployment_region}_${var.environment}"
  resource_group_name  = azurerm_resource_group.sgirm.name
  virtual_network_name = azurerm_virtual_network.sgirm.name
  address_prefixes     = var.subnet2_prefix
  delegation {
    name = "sgiapedevdbrdelgt"

    service_delegation {
      name    = "Microsoft.Databricks/workspaces"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_network_security_group" "sgirm" {
  name                = "${var.prefix}_nsg_${var.deployment_region}_${var.environment}"
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
resource "azurerm_subnet_network_security_group_association" "sgirm1" {
  subnet_id                 = azurerm_subnet.sgirm1.id
  network_security_group_id = azurerm_network_security_group.sgirm.id
}

resource "azurerm_subnet_network_security_group_association" "sgirm" {
  subnet_id                 = azurerm_subnet.sgirm.id
  network_security_group_id = azurerm_network_security_group.sgirm.id
}

resource "azurerm_network_interface" "sgirm" {
  name                = "${var.prefix}_ninf_${var.deployment_region}_${var.environment}"
  location            = azurerm_resource_group.sgirm.location
  resource_group_name = azurerm_resource_group.sgirm.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sgirm1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "sgirm" {
  network_interface_id      = azurerm_network_interface.sgirm.id
  network_security_group_id = azurerm_network_security_group.sgirm.id
}
resource "azurerm_databricks_workspace" "sgirm" {
  name                = "${var.prefix}_dbr_${var.deployment_region}_${var.environment}"
  resource_group_name = azurerm_resource_group.sgirm.name
  location            = azurerm_resource_group.sgirm.location
  sku                 = "premium"
  managed_resource_group_name =   azurerm_resource_group.sgirmdbr.name
}
provider "databricks" {
  azure_workspace_resource_id = azurerm_databricks_workspace.sgirm.id
}
resource "databricks_user" "me" {
  user_name = "chettys@basfad.basf.net"
  allow_cluster_create = true
}
resource "databricks_user" "me1" {
  user_name = "mahmoosy@basfad.basf.net"
  allow_cluster_create = true
}
resource "databricks_group" "this" {
  display_name = "Data Engineers"
  allow_instance_pool_create = true
}
resource "databricks_group_member" "admin-team" {
    group_id  = databricks_group.this.id
    member_id = databricks_user.me.id
}
resource "databricks_group_member" "data-team" {
    group_id  = databricks_group.this.id
    member_id = databricks_user.me1.id
}
resource "databricks_cluster" "shared_autoscaling" {
  cluster_name            = "Shared Autoscaling"
  spark_version           = "7.0.x-scala2.12"
  node_type_id            = "Standard_DS3_v2"
  autotermination_minutes = 20
  autoscale {
    min_workers = 1
    max_workers = 8
  }
}