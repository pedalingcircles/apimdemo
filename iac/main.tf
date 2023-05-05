

resource "azurerm_resource_group" "rg" {
  name     = "mijohns-apimdemo-sbx"
  location = "West US"
}

resource "azurerm_api_management" "api" {
  name                = "apim-contoso-demo-mijohns-sbx"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_email     = "admin@contoso.com"
  publisher_name      = "Constoso"
  sku_name            = "${var.sku}_${var.sku_count}"
}
