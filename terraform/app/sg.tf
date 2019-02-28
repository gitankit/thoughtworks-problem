resource "aws_security_group" "app" {
   name = "application"
   description = "Used for tomcat web application"
   vpc_id = "${var.vpc_id}"
   
#   ingress {
#      from_port = 80
#      to_port   = 80
#      protocol  = "http"
#      security_groups = ["${var.elb_sg}"]
#   }

  
}

output "sg_id" {
   value = "${aws_security_group.app.id}"
}
