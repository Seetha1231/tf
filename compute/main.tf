resource "aws_key_pair" "key-auth" {
  key_name = "{var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "webserver" {
  instance_type = "${var.instance-type}"
  ami = "${var.ami}"
  tags ={
      Name = "webserver"
  }

  key_name = "${aws_key_pair.key-auth.id}"
  
  vpc_security_group_ids = [
      "${var.security-group-web}"
  ]
  subnet_id = "${var.subnet-id-web}"

  provisioner "chef" {
    connection {
      host = "${self.public_ip}"
      type = "ssh"
      user = "ec2-user"
      private_key = "${file(var.private_key_path)}"
    }

    environment = "test"
    client_options = ["chef_license 'accept'"]
    run_list = ["role[testing]"]
    node_name = "webserver"
    secret_key = "${file(var.private_key_path)}"
    server_url = "https://api.chef.io/organizations/chef-seetha"
    recreate_client = true
    user_name = "seetha123"
    user_key = "${file(var.user_key_path)}"
    version = "15.7.32"
    ssl_verify_mode = ":verify_none"
  }

  provisioner "local-exec" {
    command = "knife node delete ${self.id} -y; knife client delete ${self.id} -y"
    when = "destroy"
    on_failure = "continue"
  }

}

resource "aws_instance" "appserver" {
    instance_type = "${var.instance-type}"
  ami = "${var.ami}"
  tags ={
      Name = "appserver"
  }
  key_name = "${aws_key_pair.key-auth.id}"
  vpc_security_group_ids = [
    "${var.security-group-app}"
  ]

  subnet_id = "${var.subnet-id-app}" 
   provisioner "chef" {
    connection {
      host = "${self.private_ip}"
      type = "ssh"
      user = "ec2-user"
      private_key = "${file(var.private_key_path)}"
    }

    environment = "test"
    client_options = ["chef_license 'accept'"]
    run_list = ["role[tomcat]"]
    node_name = "appserver"
    secret_key = "${file(var.private_key_path)}"
    server_url = "https://api.chef.io/organizations/chef-seetha"
    recreate_client = true
    user_name = "seetha123"
    user_key = "${file(var.user_key_path)}"
    version = "15.7.32"
    ssl_verify_mode = ":verify_peer"
  }
}



