data "aws_availability_zones" "available_zone" {
    state = "available"
}

resource "aws_vpc" "vpc_1" {
  cidr_block = "${var.vpc_cidr}"
  tags = {
      Name = "myVPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc_1.id}"

  tags = {
      Name = "VPC_1_IGW"
  }
}

resource "aws_route_table" "route_table_pub" {
  vpc_id = "${aws_vpc.vpc_1.id}"
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.igw.id}"
  }
}

# resource "aws_default_route" "private_rt" {

# }

resource "aws_subnet" "subnet_public" {
  vpc_id = "${aws_vpc.vpc_1.id}"
  cidr_block = "${var.webserver_cidr_block}"
  map_public_ip_on_launch = true
  availability_zone = "${data.aws_availability_zones.available_zone.names[0]}"
  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_subnet" "subnet_private" {
    vpc_id = "${aws_vpc.vpc_1.id}"
    cidr_block = "${var.appserver_cidr_block}"
    availability_zone = "${data.aws_availability_zones.available_zone.names[1]}"
    tags = {
        Name = "PrivateSubnet"
    }
}



resource "aws_route_table_association" "pub_ass" {
  subnet_id = "${aws_subnet.subnet_public.id}"
  route_table_id = "${aws_route_table.route_table_pub.id}"
}

resource "aws_route_table_association" "priv_ass" {
  subnet_id = "${aws_subnet.subnet_private.id}"
  route_table_id = "${aws_vpc.vpc_1.default_route_table_id}"
}

resource "aws_security_group" "security_group_web" {
    name = "WebSG"
    description = "Security for web server"
    vpc_id = "${aws_vpc.vpc_1.id}"
    # depends_on = [var.appserver]


    #SSH
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.my_ip}"]
    }

    #HTTP
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    #HTTPS
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # tomcat port
    egress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        security_groups = ["${aws_security_group.security_group_app.id}"]
    }

        egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = ["${aws_security_group.security_group_app.id}"]
    }

  #   egress {
  #     from_port       = 0
  #     to_port         = 0
  #     protocol        = "-1"
  #     cidr_blocks     = ["0.0.0.0/0"]
  # }
  
}

resource "aws_security_group" "security_group_app" {
  name = "AppSG"
  description = "Secutiry for app server"
  vpc_id = "${aws_vpc.vpc_1.id}"
  # depends_on = [var.webserver, var.dbserver]

  #SSH
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["${var.my_ip}"]
  }

  #8080
  # ingress {
  #   from_port = 8080
  #   to_port = 8080
  #   protocol = "tcp"
  #   security_groups = ["${aws_security_group.websg.id}"]
  # }
  # # #MySql
  # egress {
  #   from_port = 3306
  #   to_port = 3306
  #   protocol = "tcp"
  #   security_groups = ["${aws_security_group.rds.id}"]
  # }
}
resource "aws_security_group" "security_group_rds" {
  name = "RdsSG"
  description = "Security for RDS MySQL server"
  vpc_id = "${aws_vpc.vpc_1.id}"

  #Mysql
  # ingress {
  #   from_port = 3306
  #   to_port = 3306
  #   protocol = "tcp"
  #   security_groups = ["${aws_security_group.appsg.id}"]
  # }

  #No o/b
  
}

resource "aws_subnet" "subnet_rds" {
  count = 2
  vpc_id = "${aws_vpc.vpc_1.id}"
  cidr_block = "${element(var.dbserver_cidr_block, count.index)}"
  availability_zone = "${element(data.aws_availability_zones.available_zone.names, count.index)}"

}

resource "aws_db_subnet_group" "subnet_group_db" {
  name = "rds-subnet-group"
  description = "RDS subnet group"
  subnet_ids = "${aws_subnet.subnet_rds.*.id}"
}

resource "aws_security_group_rule" "app-web-in" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  security_group_id = "${aws_security_group.security_group_app.id}"
  source_security_group_id = "${aws_security_group.security_group_web.id}"
}

resource "aws_security_group_rule" "app-web-ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = "${aws_security_group.security_group_app.id}"
  source_security_group_id = "${aws_security_group.security_group_web.id}"
}

resource "aws_security_group_rule" "app-rds-out" {
  type = "egress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  security_group_id = "${aws_security_group.security_group_app.id}"
  source_security_group_id = "${aws_security_group.security_group_rds.id}"
}

resource "aws_security_group_rule" "rds-app-in" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  security_group_id = "${aws_security_group.security_group_rds.id}"
  source_security_group_id = "${aws_security_group.security_group_app.id}"
}

# resource "aws_eip" "eip" {
#   vpc = true 
#   # instance = "${var.appserver.id}"
# }

resource "aws_eip" "eip-nat" {
  vpc = true
}



resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.eip-nat.id}"
  # allocation_id = "eipalloc-072c121647f14eef6"
  subnet_id = "${aws_subnet.subnet_public.id}"
  tags ={
    Name = "nat-gw"
  }
}

resource "aws_route" "add-nat-pr" {
  route_table_id =  "${aws_vpc.vpc_1.default_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.nat_gw.id}"
}