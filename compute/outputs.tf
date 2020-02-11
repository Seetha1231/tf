output "appserver_private_ip" {
  value = "${aws_instance.appserver.private_ip}"
}

output "webserver_public_ip" {
  value = "${aws_instance.webserver.public_ip}"
}






