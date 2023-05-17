#resource "dns_a_record_set" "primary_application_gateway" {
#  provider = dns
#  addresses = [azurerm_application_gateway.primary_application_gateway.frontend_ip_configuration[0].private_ip_address]
#  zone  = "${var.domains["internal"]}."
#  name     = var.application_gateways["primary"].hostname
#  ttl      = 3600
#}
