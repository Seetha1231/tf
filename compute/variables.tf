variable "key_name" {
  type = string
  default = "ec2-key"
  description = "Key Name of ec2 instance"
}


variable "public_key_path" {
  type = string
  default = "/Users/seethalakshmi/.ssh/id_rsa.pub"
  description = "Public key path from local machine"
}

variable "private_key_path" {
  type = string
  default = "/Users/seethalakshmi/.ssh/id_rsa"
  description = "Private key path from local machine"
}


variable "user_key_path" {
  type = string
  default = "/Users/seethalakshmi/Downloads/seetha123.pem"
  description = "User key (chef server) path"
}

variable "security-group-web" {
  type = string
  description = "security group id of web server"

}

variable "security-group-app" {
  type = string
  description = "security group id of app server"
}

variable "subnet-id-web" {
  type = string
  description = "subnet id of web server"
}

variable "subnet-id-app" {
  type = string
  description = "subnet id of app server"
}

variable "instance-type" {
  default = "t2.micro"
  description = "type of ec2 instance"
}

variable "ami" {
  default = "ami-062f7200baf2fa504"
  description = "image(type of os) of ec2 instance"
}




