variable "vpc_cidr" {
  description = "cidr block of vpc"
  default = "10.12.0.0/16"
}

variable "webserver_cidr_block" {
  description = "cidr block of web server"
  default = "10.12.1.0/24"
}

variable "appserver_cidr_block" {
  description = "cidr block of app server"
  default = "10.12.2.0/24"
}
variable "dbserver_cidr_block" {
  description = "cidr blocks for db server"
  default = ["10.12.3.0/24", "10.12.4.0/24"]
}

variable "my_ip" {
  description = "cidr block of local machine"
  default = "115.110.139.185/32"
}
