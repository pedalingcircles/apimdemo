locals {
  sub_env_tags = merge(var.subscription_tags, var.environment.tags)
  admin_username = "LocalAdmin"
  admin_ssh_key  = "localadmin.pub"
  backend_pool_ips = [
    "10.5.245.37"
  ]
}
