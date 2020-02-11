output "vpc" {
  value = "${aws_vpc.vpc_1.id}"
}

output "subnet_id_web" {
  value = "${aws_subnet.subnet_public.id}"
}

output "subnet_id_app" {
  value = "${aws_subnet.subnet_private.id}"
}

output "security_group_web" {
  value = "${aws_security_group.security_group_web.id}"
}

output "security_group_app" {
  value = "${aws_security_group.security_group_app.id}"
}

output "security_group_rds" {
  value = "${aws_security_group.security_group_rds.id}"
}

output "subnet_id_rds" {
  value = "${aws_db_subnet_group.subnet_group_db.id}"
}

output "eip" {
  value = "${aws_eip.eip-nat.id}"
}