resource "aws_security_group" "app" {
   name = "application"
   description = "Used for tomcat web application"
   vpc_id = "${var.vpc_id}"
}

output "sg_id" {
   value = "${aws_security_group.app.id}"
}

