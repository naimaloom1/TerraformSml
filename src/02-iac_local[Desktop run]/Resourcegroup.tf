terraform {
     required_providers {
    databricks = {
      source = "databrickslabs/databricks"
      version = "0.2.8"
    }
  }
}

locals {
	prefix_upper = upper("${var.prefix}")
	environment_upper = upper("${var.environment}")
	deployment_region_upper = upper("${var.deployment_region}")
	}

data "azurerm_client_config" "current" {}

provider "azurerm" {
version = "=2.20.0"
features {}
}

resource "azurerm_resource_group" "sgirm" {
  name     = "${local.prefix_upper}_RG_${local.deployment_region_upper}_${local.environment_upper}"
  location = var.location
}

resource "azurerm_resource_group" "sgirmdbr" {
  name     = "${local.prefix_upper}_RG_DBR_${local.deployment_region_upper}_${local.environment_upper}"
  location = var.location  
}

