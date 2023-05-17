#output "test_out" {
#  value = local.primary_vm_ips
#}
#
#output "nsg_resource_details" {
#  value = {for d_type in local.deployment_types: d_type => {
#    resource_group = data.azurerm_network_security_group.azure_lb_nsg[d_type].resource_group_name,
#    nsg_name = data.azurerm_network_security_group.azure_lb_nsg[d_type].name}
#  }
#}
#
#output "vm_disks" {
#  value = local.vm_datadisks
#}
#
#output "hostnames_and_ips" {
#  value = { for k, v in local.vm_with_count: k => {for vm in v: vm => module.resources["${k}:${vm}"].hostnames_and_ips}}
#}
#
#output "vm_resource_ids" {
#  value = { for k, v in local.vm_with_count: k => {for vm in v: vm => module.resources["${k}:${vm}"].vm_resource_ids}}
#}
#
#output "lb_dns" {
#  value = { for k, v in local.vm_with_count: k => {for vm in v: vm => module.resources["${k}:${vm}"].lb_frontend_aliases}}
#}
#
#output "lbfrontend_ips" {
#  value = { for k, v in local.vm_with_count: k => {for vm in v: vm => module.resources["${k}:${vm}"].load_balancer_ips}}
#}
#
#output "primary_hostname" {
#  value = { for k, v in local.vm_with_count: k => {for vm in v: vm => module.resources["${k}:${vm}"].primary_hostnames}}
#}
#
#output "ha_hostname" {
#  value = { for k, v in local.vm_with_count: k => {for vm in v: vm => module.resources["${k}:${vm}"].ha_hostnames}}
#}
#
#output "hana_installer" {
#  value = var.config.ciSoftware
#}
#
#output "ha_resource_values" {
#  value = flatten(concat([for k, v in local.vm_with_count: [for vm in v: module.resources["${k}:${vm}"].lb_frontend_aliases]]))
#}
#
#
#
#
#
#
#output "ec2_db_private_ips" {
#  value = [aws_instance.ec2_db.*.private_ip]
#}
#
#output "ec2_app_private_ips" {
#  value = [aws_instance.ec2_app.*.private_ip]
#}
#
##output "ec2_ReportingServerDB_private_ips" {
##  value = [aws_instance.ec2_ReportingServerDB.*.private_ip]
##}
#
#output "kms_key_id" {
#  value = aws_kms_key.onesource.key_id
#}
#
#output "elb_app_r53" {
#  value = [aws_route53_record.r53_elb.*.fqdn]
#}
#
#output "ext_elb_app_r53" {
#  value = [aws_route53_record.r53_elb_ext.*.fqdn]
#}
#
#output "vpc_id" {
#  value = ["$var.vpc_id"]
#}
#
##output "S3_access_key_id"{
#  #value = aws_iam_access_key.user_keys.id
##}
#
##output "S3_access_key_secret"{
#  #value = aws_iam_access_key.user_keys.secret
##}
