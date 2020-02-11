output "vpc_id" {
  value = "${module.networking.vpc}"
}

output "elastic_ip" {
  value = "${module.networking.eip}"
}

output "subnet_id_appserver" {
  value = "${module.networking.subnet_id_web}"
}

output "subnet_id_webserver" {
  value = "${module.networking.subnet_id_app}"
}

output "subnet_id_rds" {
  value = "${module.networking.subnet_id_rds}"
}

output "security_group_id_webserver" {
  value = "${module.networking.security_group_web}"
}

output "security_group_id_appserver" {
  value = "${module.networking.security_group_app}"
}

output "security_group_id_rds" {
  value = "${module.networking.security_group_rds}"
}

output "appserver_private_ip" {
  value = "${module.compute.appserver_private_ip}"
}

output "webserver_public_ip" {
  value = "${module.compute.webserver_public_ip}"
}

output "db_endpoint" {
  value = "${module.dbinstance.db_endpoint}"
}
