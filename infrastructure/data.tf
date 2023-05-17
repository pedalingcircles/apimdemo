data "azurerm_resource_group" "primary_resource_group" {
  name     = var.deployment_resource_group["primary"]
}

data "azurerm_virtual_network" "primary_vnet" {
  name                = var.networks["primary"].name
  resource_group_name = var.networks["primary"].resource_group
}

data "azurerm_subnet" "primary_subnets" {
  for_each             = var.networks["primary"].subnets
  name                 = each.value.name
  virtual_network_name = data.azurerm_virtual_network.primary_vnet.name
  resource_group_name  = data.azurerm_virtual_network.primary_vnet.resource_group_name
}

data "azurerm_network_security_group" "primary_nsg" {
  name                = var.network_security_groups["primary"].name
  resource_group_name = var.network_security_groups["primary"].resource_group
}

data "azurerm_public_ip" "primary_application_gateway_public_ip" {
  name = var.application_gateways["primary"].public_ip
  resource_group_name = var.deployment_resource_group["primary"]
}

data "azurerm_application_security_group" "linux_dmz_asg" {
  name                = var.network_security_groups["primary"].asgs["linux-dmz"]
  resource_group_name = var.network_security_groups["primary"].resource_group
}
