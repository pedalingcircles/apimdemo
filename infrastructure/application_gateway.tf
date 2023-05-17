resource "azurerm_application_gateway" "primary_application_gateway" {
  name                = var.application_gateways["primary"].name
  resource_group_name = data.azurerm_resource_group.primary_resource_group.name
  location            = var.regions["primary"].location
  tags                = merge(local.sub_env_tags, var.application_gateways["primary"].tags)

  lifecycle {
    ignore_changes = all
  }

  sku {
    name     = var.application_gateways["primary"].sku_name
    tier     = var.application_gateways["primary"].sku
    capacity = var.application_gateways["primary"].sku_capacity
  }

  waf_configuration{
    enabled = false
    firewall_mode = "Detection"
    rule_set_version = "3.0"
  }

  gateway_ip_configuration {
    name      = "${var.application_gateways["primary"].name}-ip-config"
    subnet_id = data.azurerm_subnet.primary_subnets["ag"].id
  }

  ssl_certificate {
    name     = var.application_gateways["primary"].cert_name
    data     = filebase64("files/${var.environment.longname}/${var.application_gateways["primary"].cert_name}")
    password = var.application_gateways["primary"].cert_pwd
  }

  ssl_policy {
    policy_name          = "AppGwSslPolicy20220101"
    policy_type          = "Predefined"
    min_protocol_version = "TLSv1_2"
    cipher_suites = [
      "TLS_RSA_WITH_AES_128_GCM_SHA256",
      "TLS_RSA_WITH_AES_256_GCM_SHA384",
      "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256",
      "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384",
      "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
      "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
      "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256",
      "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384",
      "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256",
      "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384"
    ]
  }

  trusted_root_certificate {
    name = var.application_gateways["primary"].root_certs["entrust"]
    data = filebase64("files/${var.environment.longname}/${var.application_gateways["primary"].root_certs["entrust"]}")
  }

  trusted_root_certificate {
    name = var.application_gateways["primary"].root_certs["contoso_tls"]
    data = filebase64("files/${var.environment.longname}/${var.application_gateways["primary"].root_certs["contoso_tls"]}")
  }

  trusted_root_certificate {
    name = var.application_gateways["primary"].root_certs["digicert"]
    data = filebase64("files/${var.environment.longname}/${var.application_gateways["primary"].root_certs["digicert"]}")
  }

  frontend_port {
    name = "${var.application_gateways["primary"].name}-frontend-port-443"
    port = 443
  }

  frontend_port {
    name = "${var.application_gateways["primary"].name}-frontend-port-80"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "${var.application_gateways["primary"].name}-frontend-ip-config"
    public_ip_address_id = data.azurerm_public_ip.primary_application_gateway_public_ip.id
  }

#  frontend_ip_configuration {
#    name                 = "${var.application_gateways["primary"].name}-frontend-ip-config-private"
#    subnet_id = data.azurerm_subnet.primary_subnets["sap"].id
#    private_ip_address_allocation = "Dynamic"
#  }

  backend_address_pool {
    name = "${var.application_gateways["primary"].name}-backend-pool"
    ip_addresses = local.backend_pool_ips
  }

  http_listener {
    name                           = "${var.application_gateways["primary"].name}-https-listener"
    frontend_ip_configuration_name = "${var.application_gateways["primary"].name}-frontend-ip-config"
    frontend_port_name             = "${var.application_gateways["primary"].name}-frontend-port-443"
    protocol                       = "Https"
    host_names                     = [var.domains["public_host_name"]]
    ssl_certificate_name           = var.application_gateways["primary"].cert_name
  }

  http_listener {
    name                           = "${var.application_gateways["primary"].name}-http-listener"
    frontend_ip_configuration_name = "${var.application_gateways["primary"].name}-frontend-ip-config"
    frontend_port_name             = "${var.application_gateways["primary"].name}-frontend-port-80"
    protocol                       = "Http"
    host_names                     = [var.domains["public_host_name"]]
  }

  request_routing_rule {
    name                       = "${var.application_gateways["primary"].name}-https-routing-rule"
    rule_type                  = "Basic"
    priority                   = "10"
    http_listener_name         = "${var.application_gateways["primary"].name}-https-listener"
    backend_address_pool_name  = "${var.application_gateways["primary"].name}-backend-pool"
    backend_http_settings_name = "${var.application_gateways["primary"].name}-https-settings"
  }

  request_routing_rule {
    name                       = "${var.application_gateways["primary"].name}-http-routing-rule"
    rule_type                  = "Basic"
    priority                   = "11"
    http_listener_name         = "${var.application_gateways["primary"].name}-http-listener"
    backend_address_pool_name  = "${var.application_gateways["primary"].name}-backend-pool"
    backend_http_settings_name = "${var.application_gateways["primary"].name}-http-settings"
  }

  backend_http_settings {
    name                  = "${var.application_gateways["primary"].name}-https-settings"
    cookie_based_affinity = "Disabled"
    path                  = ""
    port                  = 443
    protocol              = "Https"
    request_timeout       = 1200
    host_name             = var.domains["public_host_name"]
    probe_name            = "${var.application_gateways["primary"].name}-https-probe"
    trusted_root_certificate_names = [
      var.application_gateways["primary"].root_certs["entrust"],
      var.application_gateways["primary"].root_certs["contoso_tls"],
      var.application_gateways["primary"].root_certs["digicert"]
    ]
  }

  backend_http_settings {
    name                  = "${var.application_gateways["primary"].name}-http-settings"
    cookie_based_affinity = "Disabled"
    path                  = ""
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1200
    host_name             = var.domains["public_host_name"]
    probe_name            = "${var.application_gateways["primary"].name}-http-probe"
  }

  probe {
    name                                      = "${var.application_gateways["primary"].name}-https-probe"
    protocol                                  = "Https"
    path                                      = "/status-0123456789abcdef"
    interval                                  = "30"
    timeout                                   = "10"
    unhealthy_threshold                       = "3"
    pick_host_name_from_backend_http_settings = false
    host                                      = var.domains["public_host_name"]
  }

  probe {
    name                                      = "${var.application_gateways["primary"].name}-http-probe"
    protocol                                  = "Http"
    path                                      = "/status-0123456789abcdef"
    interval                                  = "30"
    timeout                                   = "10"
    unhealthy_threshold                       = "3"
    pick_host_name_from_backend_http_settings = false
    host                                      = var.domains["public_host_name"]
  }

}

resource "azurerm_user_assigned_identity" "primary_ag_identity" {
  location            = var.regions["primary"].location
  resource_group_name = data.azurerm_resource_group.primary_resource_group.name
  name                = "${var.application_gateways["primary"].user_assigned_identity}-msi"
  tags                = local.sub_env_tags

  lifecycle {
    ignore_changes = all
  }
}
