resource "aws_security_group" "static" {
   name = "static-resources"
   description = "Used for static images and styles"
   vpc_id = "${var.vpc_id}"
   
#   ingress {
#      from_port = 80
#      to_port   = 80
#      protocol  = "http"
#      security_groups = ["${var.elb_sg}"]
#   }

  
}

output "sg_id" {
   value = "${aws_security_group.static.id}"
}
