# environment settings
environment = {
  longname                 = "qa"
  shortname                = "qa"
  abbrev                   = "q"
  tags                     = {
    Environment      = "qa"
    Cluster          = "qa"
    contoso-environment = "nonprod"
    contoso-application = "sap-if"
  }
  az_subscription_char     = "n"
  az_subscription_longname = "nonprod"
}

domains = {
  internal                = "if.contoso.com"
  external                = "if.contoso.com"
  public_host_name        =  "qa.api.if.contoso.com"
}

deployment_resource_group = {
  primary = "c0-sap-rg-if-qa"
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
        name = "n5-sn-10.6.8.0-22"
        cidr = "10.6.8.0/22"
      }
      ag = {
        name = "n5-sn-10.6.12.0-24"
        cidr = "10.6.12.0/24"
      }
      apim = {
        name = "n5-sn-10.6.13.0-27"
        cidr = "10.6.13.0/27"
      }
    }
  }
}

network_security_groups = {
  primary_dmz = {
    region         = "primary"
    name           = "n5-sap01-nsg-westus2-dmz-02"
    resource_group = "c0-sap01-net_usw2-rg-01"
    asgs           = {}
  }
  primary = {
    region         = "primary"
    name           = "n5-sap01-nsg-westus2-dmz"
    resource_group = "c0-sap01-net_usw2-rg-01"
    asgs = {
      linux-dmz = "LinuxServer-DMZ"
      # TODO - bb - need to create new asg for if
      # if     = "n5-sap01-asg-westus2-if"
    }
  }
}

# resources
application_gateways = {
  primary = {
    region    = "primary"
    name      = "c0-sap01-if-qa-ag"
    hostname  = "ag"
    public_ip = "c0-sap01-if-uswest2-pip-02"
    root_cert              = "Entrust-Root-Certification-Authority-G2.cer"
    cert_name              = "qa.api.if.contoso.com.pfx"
    cert_pwd               = "contosocontoso1234"
    affinity_cookie_name   = "if-qa-affinity-cookie"
    sku                    = "WAF_v2"
    sku_name               = "WAF_v2"
    sku_capacity           = 2
    user_assigned_identity = "if-qa-ag-identity"
    tags                   = {}
  }
}

app_insights = {
  primary = {
    name             = "c0-sap01-if-qa-appinsights"
    application_type = "other"
    workspace_name   = "c0-sap01-westus2-if-qa-law-01"
    workspace_sku    = "PerGB2018"
    tags             = {}
  }
}

apims = {
  primary = {
    name                 = "c0-sap01-if-qa-apim"
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
        file = "qa.api.if.contoso.com.pfx"
        password = "contosocontoso1234"
      }
    }
    root_certificates = {
      contoso-Root-Authority-NG = {
        file = "contoso-Root-Authority-NG.cer"
        password = ""
      }
    }
    tags                 = {}
  }
}

key_vaults = {
  primary = {
    name = "c0-sap01-if-qa-kv"
    tags = {}
  }
}
