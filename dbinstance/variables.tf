variable "id" {
  type = string
  description = "Identifier of the mysql instance"
  default = "rds-mysql"
}

variable "storage_size" {
  type = number
  description = "allocated size to db"
  default = 20
}

variable "engine_type" {
  type = string
  description = "Type of storage"
  default = "gp2"
}

variable "engine_name" {
  type = string
  description = "db engine name"
  default = "mysql"
}

variable "instance_class" {
  type = string
  description = "Db instance class"
  default = "db.t2.micro"
}

variable "db_name" {
  type = string
  description = "db name"
  default = "mydb"
}

variable "db_username" {
  type = string 
  description = "db user name"
  default = "root"
}

variable "db_password" {
  type = string
  description = "db password"
  default = "seetha123"
}

variable "security-group-rds" {
  description = "Security Group of rds instance ref"  
}

variable "subnet-id-rds" {
  description = "Subnet Id for rds created in networking and getting by module"
}