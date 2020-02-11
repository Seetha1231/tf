resource "aws_db_instance" "mydb" {
  identifier = "rds-mysql"
  allocated_storage    = "${var.storage_size}"
  storage_type         = "${var.engine_type}"
  engine               = "${var.engine_name}"
  engine_version       = "5.7"
  instance_class       = "${var.instance_class}"
  name                 = "${var.db_name}"
  username             = "${var.db_username}"
  password             = "${var.db_password}"
  parameter_group_name = "default.mysql5.7"
  vpc_security_group_ids = [
       "${var.security-group-rds}"
  ]
  skip_final_snapshot = true
  final_snapshot_identifier = "Ignore"
  db_subnet_group_name = "${var.subnet-id-rds}"
}