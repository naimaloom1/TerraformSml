variable "location" {
    type    = string
}

variable "environment" {
    type    = string
}

variable "prefix" {
    type    = string
}



variable "vnet_cidr_range" {
    type    = list(string)
    default = ["10.9.0.0/16"]
}

variable "subsql_prefix" {
    type    =  list(string)
    default = ["10.9.0.0/18"]
}

variable "deployment_region" {
    type    = string
}

variable "subnet1_prefix" {
    type    = list(string)
    default = ["10.9.64.0/18"]
}



variable "subnet2_prefix" {
    type    = list(string)
    default = ["10.9.128.0/18"]
}


variable "azurerm_client_config_current_tenant_id" {
    type    = string
    default = "2f4a9838-26b7-47ee-be60-ccc1fdec5953"
}

variable "azurerm_client_config_current_object_id" {
    type    = string
    default = "2ff814a6-3304-4ab8-85cb-cd0e6f879c1d"
}

