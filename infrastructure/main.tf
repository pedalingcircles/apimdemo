terraform {
  backend "azurerm" {
    resource_group_name  = "scef-sapae-devops-persistent"
    storage_account_name = "scefsapaedevopsstorage"
    container_name       = "tfstate"
    key                  = "asapi/asapi.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.40.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.az_subscription_id
  client_id       = var.az_client_id
  client_secret   = var.az_client_secret
  tenant_id       = var.az_tenant_id
  skip_provider_registration = true
  features {}
}

provider "dns" {
  update {
    server        = var.dns_update_server
    key_name      = "${var.dns_update_key_name}."
    key_algorithm = var.dns_update_key_algorithm
    key_secret    = var.dns_update_key_secret
  }
}
