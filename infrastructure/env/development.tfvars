# environment settings
environment = {
  longname                 = "development"
  shortname                = "dev"
  abbrev                   = "d"
  tags                     = {
    Environment      = "development"
    Cluster          = "development"
    contoso-environment = "nonprod"
    contoso-application = "sap-if"
    contoso-tagguid     = "fixthis"
  }
  az_subscription_char     = "n"
  az_subscription_longname = "nonprod"
}

domains = {
  internal                = "if.contoso.com"
  external                = "if.contoso.com"
  public_host_name        =  "dev.api.if.contoso.com"
}

deployment_resource_group = {
  primary = "c0-sap-rg-if-dev"
}

regions = {
  primary = {
    location             = "westus2"
    dns_region_subdomain = "usw2"
  }
  dr = {
    location             = "eastus"
    dns_region_subdomain = "use1"
  }
}

# network settings
networks = {
  primary = {
    region         = "primary"
    name           = "n5-sap01-vnet-westus2-01"
    resource_group = "c0-sap01-rg-network-01"
    subnets = {
      sap = {
        name = "c5-sn-10.5.8.0-22"
        cidr = "10.6.8.0/22"
      }
      ag = {
        name = "nc5-sn-10.5.12.0-24"
        cidr = "10.6.12.0/24"
      }
      apim = {
        name = "c5-sn-10.5.13.0-27"
        cidr = "10.6.13.0/27"
      }
    }
  }
}

network_security_groups = {
  # TODO - bb - NSG - Should not need this - AG is layer 7 firewall
  primary_dmz = {
    region         = "primary"
    name           = "c5-sap01-nsg-westus2-dmz-02"
    resource_group = "nc0-sap01-net_usw2-rg-01"
    asgs           = {}
  }
  primary = {
    region         = "primary"
    name           = "c5-sap01-nsg-westus2-dmz"
    resource_group = "c0-sap01-net_usw2-rg-01"
    asgs = {
      linux-dmz = "LinuxServer-DMZ"
      # TODO - bb - need to create new asg for if
      # if     = "n5-sap01-asg-westus2-if"
    }
  }
}

# resources
app_services = [
  {
    app_name      = "c0-sap-if-dev-nsp-receive"
    region = "primary"
    plan_name     = "c0-sap01-if-dev-as"
    plan_sku = "EP1"
    tags          = {}
  }
]

service_buses = [
  {
    name = "c0-sap01-if-dev-sb-01"
    region = "primary"
    sku  = "Standard"
    queues = {
      test_queue = {
        namespace = "test_namespace"
      }
    }
    tags = {}
  }
]

logic_apps = [
  {
    name                = "c0-sap01-if-dev-la-primary"
    region              = "primary"
    tags                = {}
  }
]

application_gateways = {
  primary = {
    region    = "primary"
    name      = "c0-sap01-if-ag"
    hostname  = "dev.api.if.contoso.com"
    public_ip = "c0-sap01-if-uswest2-pip-01"
    root_certs             = {
      entrust = "Entrust-Root-Certification-Authority-G2.cer",
      contoso_tls = "contoso-TLS-CA.pem",
      digicert = "DigiCertGlobalRootG2.cer"
    }
    cert_name              = "dev.api.if.contoso.com.pfx"
    cert_pwd               = "contosocontoso1234"
    affinity_cookie_name   = "if-affinity-cookie"
    sku                    = "WAF_v2"
    sku_name               = "WAF_v2"
    sku_capacity           = 2
    user_assigned_identity = "if-ag-identity"
    tags                   = {}
  }
}

apims = {
  primary = {
    name                 = "c0-sap01-if-apim"
    sku                  = "Premium_1"
    virtual_network_type = "Internal"
    publisher_email      = "foo.bar@contoso.com"
    publisher_name       = "testing"
    ca_certificates = {
      Entrust-Root-Certification-Authority-G2 = {
        file = "Entrust-Root-Certification-Authority-G2.cer"
        password = ""
      }
      contoso-Root-Authority-NG = {
        file = "contoso-Root-Authority-NG.cer"
        password = ""
      }
      if-ROOT = {
        file = "dev.api.if.contoso.com.pfx"
        password = "contosocontoso1234"
      }
    }
    root_certificates = {
      Entrust-Root-Certification-Authority-G2 = {
        file = "Entrust-Root-Certification-Authority-G2.cer"
        password = ""
      }
      contoso-Root-Authority-NG = {
        file = "contoso-Root-Authority-NG.cer"
        password = ""
      }
      if-ROOT = {
        file = "dev.api.if.contoso.com.pfx"
        password = "contosocontoso1234"
      }
    }
    tags                 = {}
  }
}

storage_accounts = {
  primary = {
    region      = "primary"
    name        = "c0sap01ifdevsa"
    replication = "LRS"
    sku         = "Standard"
    containers = {
      access-logs = {
        access_type = "private"
      },
      azure-webjobs-hosts = {
        access_type = "private"
      }
      azure-webjobs-secrets = {
        access_type = "private"
      }
    }
    tags = {}
  }
}

app_insights = {
  primary = {
    name             = "c0-sap01-if-dev-appinsights"
    application_type = "other"
    workspace_name   = "c0-sap01-westus2-if-dev-law-01"
    workspace_sku    = "PerGB2018"
    tags             = {}
  }
}

key_vaults = {
  primary = {
    name = "c0-sap01-if-kv-01"
    tags = {}
  },
  dr = {
    name = "c0-sap01-if-dev-kv"
    tags = {}
  }
}
