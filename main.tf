provider "aws" {
  region = "${var.aws_region}"
}

module "networking" {
    source = "./networking"
    # web-ip = "${module.compute.webserver-ip}"
    # app-ip = "${module.compute.appserver-ip}"
    # db-ip = "${module.dbinstance.db-ip}"
    # appserver = "${module.compute.appserver}"
    # webserver = "${module.compute.webserver}"
    # dbserver = "${module.dbinstance.dbserver}"
}

module "compute" {
  source = "./compute"
  security-group-web = "${module.networking.security_group_web}"
  subnet-id-web = "${module.networking.subnet_id_web}"
  security-group-app = "${module.networking.security_group_app}"
  subnet-id-app = "${module.networking.subnet_id_app}"
}

module "dbinstance" {
  source = "./dbinstance"
  security-group-rds = "${module.networking.security_group_rds}"
  subnet-id-rds = "${module.networking.subnet_id_rds}"
  # subnet-id-web = "${module.networking.subnet-web}"
}
