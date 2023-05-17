#####
# COMMON
variable "dns_update_server" {
  type = string
}

#####
# SUBSCRIPTION

variable "bootdiags_storage_account" {
  type = map(any)
  default = {
    sa_tier        = "Standard"
    sa_replication = "LRS"
  }
}

#####
# ENVIRONMENT

variable "subscription_ids" {
  type = object({
    sandbox     = string
    development = string
    qa          = string
    production  = string
  })
}

variable "az_client_id" {
  type = string
}

variable "az_client_secret" {
  type = string
}

variable "az_tenant_id" {
  type = string
}

variable "az_subscription_id" {
  type = string
}

variable "az_access_key" {
  type = string
}

variable "dns_update_key_name" {
  type = string
}

variable "dns_update_key_secret" {
  type = string
}

variable "dns_update_key_algorithm" {
  type = string
}

variable "environment" {
  type = object({
    longname                 = string
    shortname                = string
    abbrev                   = string
    tags                     = map(string)
    az_subscription_char     = string
    az_subscription_longname = string
  })
}

variable "subscription_tags" {
  type = map(string)
}

variable "deployment_resource_group" {
  type = map(string)
}

variable "domains" {
  type = map(string)
}

variable "regions" {
  type = map(object({
    location             = string
    dns_region_subdomain = string
  }))
}

variable "networks" {
  type = map(object({
    region         = string
    name           = string
    resource_group = string
    subnets = map(object({
      name = string
      cidr = string
    }))
  }))
}

variable "network_security_groups" {
  type = map(object({
    region         = string
    name           = string
    resource_group = string
    asgs           = map(string)
  }))
}

#####
# RESOURCES

variable "app_services" {
  type = list(object({
    app_name = string
    region   = string
    plan_name = string
    plan_sku = string
    tags = map(string)
  }))
}

variable "service_buses" {
  type = list(object({
    name = string
    region = string
    sku = string
    tags = map(string)
    queues = map(object({
      namespace = string
    }))
  }))
}

variable "logic_apps" {
  type = list(object({
    name = string
    region = string
    tags = map(string)
  }))
}

variable "functions" {
  type = list(object({
    name = string
    region = string
    tags = map(string)
  }))
}

variable "redis_caches" {
  type = list(object({
    name = string
    region = string
    tags = map(string)
  }))
}

variable "data_explorers" {
  type = map(object({
    name = string
    region = string
    tags = map(string)
  }))
}

variable "sql_servers" {
  type = map(object({
    name = string
    region = string
    tags = map(string)
  }))
}

variable "application_gateways" {
  type = map(object({
    region                 = string
    name                   = string
    hostname               = string
    public_ip              = string
    root_certs              = map(string)
    cert_name              = string
    cert_pwd               = string
    affinity_cookie_name   = string
    sku                    = string
    sku_name               = string
    sku_capacity           = number
    user_assigned_identity = string
    tags                   = map(string)
  }))
}

variable "apims" {
  type = map(object({
    name                 = string
    sku                  = string
    virtual_network_type = string
    publisher_email      = string
    publisher_name       = string
    ca_certificates  = map(map(string))
    root_certificates     = map(map(string))
    tags                 = map(string)
  }))
}

variable "storage_accounts" {
  type = map(object({
    region      = string
    name        = string
    replication = string
    sku         = string
    tags        = map(string)
    containers  = map(object({
      access_type = string
    }))
  }))
}

variable "app_insights" {
  type = map(object({
    name             = string
    application_type = string
    workspace_name   = string
    workspace_sku    = string
    tags             = map(string)
  }))
}

variable "key_vaults" {
  type = map(object({
    name = string
    tags = map(string)
  }))
}
