resource "azurerm_resource_group" "primary_resource_group" {
  name     = var.deployment_resource_group["primary"]
  location = var.regions["primary"].location
  tags     = local.sub_env_tags
}
