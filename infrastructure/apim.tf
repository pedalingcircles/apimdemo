resource "azurerm_api_management" "apim" {
  name                 = var.apims["primary"].name
  resource_group_name  = data.azurerm_resource_group.primary_resource_group.name
  location             = var.regions["primary"].location
  sku_name             = var.apims["primary"].sku
  virtual_network_type = var.apims["primary"].virtual_network_type

  virtual_network_configuration {
    subnet_id = data.azurerm_subnet.primary_subnets["apim"].id
  }

  publisher_email = var.apims["primary"].publisher_email
  publisher_name  = var.apims["primary"].publisher_name
  tags            = merge(local.sub_env_tags, var.apims["primary"].tags)

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_api_management_gateway" "apim_gateway" {
  name              = "${var.apims["primary"].name}_gateway"
  api_management_id = azurerm_api_management.apim.id
  location_data {
    name     = "Contoso"
    city     = "Redmon"
    district = "Seattle"
    region   = "Washington"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_api_management_certificate" "apim_ca_certificates" {
  for_each = var.apims["primary"].ca_certificates
  name                = each.key
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = data.azurerm_resource_group.primary_resource_group.name
  data                = filebase64("files/${var.environment.longname}/${each.value.file}")
  password            = each.value.password

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_api_management_gateway_certificate_authority" "apim_ca" {
  for_each = azurerm_api_management_certificate.apim_ca_certificates
  api_management_id = azurerm_api_management.apim.id
  certificate_name  = each.value.name
  gateway_name      = azurerm_api_management_gateway.apim_gateway.name
  is_trusted        = true

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_api_management_certificate" "apim_root_certificates" {
  for_each = var.apims["primary"].root_certificates
  name                = each.key
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = data.azurerm_resource_group.primary_resource_group.name
  data                = filebase64("files/${var.environment.longname}/${each.value.file}")
  password            = each.value.password

  lifecycle {
    ignore_changes = all
  }
}


resource "azurerm_api_management" "primary_apim" {
  name                 = var.apims["secondary"].name
  resource_group_name  = data.azurerm_resource_group.primary_resource_group.name
  location             = var.regions["primary"].location
  sku_name             = var.apims["primary"].sku
  virtual_network_type = var.apims["primary"].virtual_network_type

  virtual_network_configuration {
    subnet_id = data.azurerm_subnet.primary_subnets["apim"].id
  }

  publisher_email = var.apims["primary"].publisher_email
  publisher_name  = var.apims["primary"].publisher_name
  tags            = merge(local.sub_env_tags, var.apims["primary"].tags)

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_api_management_gateway" "primary_apim_gateway" {
  name              = "${var.apims["secondary"].name}_gateway"
  api_management_id = azurerm_api_management.primary_apim.id
  location_data {
    name     = "Contoso"
    city     = "Redmond"
    district = "Seattle"
    region   = "Washington"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_api_management_certificate" "primary_apim_ca_certificates" {
  for_each = var.apims["primary"].ca_certificates
  name                = each.key
  api_management_name = azurerm_api_management.primary_apim.name
  resource_group_name = data.azurerm_resource_group.primary_resource_group.name
  data                = filebase64("files/${var.environment.longname}/${each.value.file}")
  password            = each.value.password

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_api_management_gateway_certificate_authority" "primary_apim_ca" {
  for_each = azurerm_api_management_certificate.primary_apim_ca_certificates
  api_management_id = azurerm_api_management.primary_apim.id
  certificate_name  = each.value.name
  gateway_name      = azurerm_api_management_gateway.primary_apim_gateway.name
  is_trusted        = true

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_api_management_certificate" "primary_apim_root_certificates" {
  for_each = var.apims["primary"].root_certificates
  name                = each.key
  api_management_name = azurerm_api_management.primary_apim.name
  resource_group_name = data.azurerm_resource_group.primary_resource_group.name
  data                = filebase64("files/${var.environment.longname}/${each.value.file}")
  password            = each.value.password

  lifecycle {
    ignore_changes = all
  }
}
