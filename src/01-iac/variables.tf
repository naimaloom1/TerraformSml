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
    default = "78bafdce-466d-4efd-a046-09a63ef257b3"
}

variable "azurerm_client_config_current_object_id" {
    type    = string
    default = "408cceff-d62f-4588-b932-7fcb66bc558d"
}

