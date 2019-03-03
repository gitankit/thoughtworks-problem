resource "aws_security_group" "static" {
   name = "static-resources"
   description = "Used for static images and styles"
   vpc_id = "${var.vpc_id}"
}

output "sg_id" {
   value = "${aws_security_group.static.id}"
}
