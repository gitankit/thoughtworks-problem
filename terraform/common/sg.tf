#Security group for load balancer
resource "aws_security_group" "applb_sg" {
   name = "companyNews_alb"
   description = "ALB for access application"
   vpc_id = "${var.vpc_id}"
   ingress {
      from_port = 443
      to_port   = 443
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
      from_port = 80 
      to_port   = 80
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }


   egress {
      from_port = 8080
      to_port   = 8080
      protocol  = "tcp"
      security_groups = ["${var.app_sg}"]
   }
   egress {
      from_port = 8080
      to_port   = 8080
      protocol  = "tcp"
      security_groups = ["${var.static_sg}"]
   }


}

#Security group rule from alb for application instance
resource "aws_security_group_rule" "app_instances_access" {
   type = "ingress"
   from_port = 8080
   to_port   = 8080
   protocol  = "tcp"
   security_group_id = "${var.app_sg}"
   source_security_group_id = "${aws_security_group.applb_sg.id}"
}

#Security group rule from alb for static instances
resource "aws_security_group_rule" "static_instances_access" {
   type = "ingress"
   from_port = 8080
   to_port   = 8080
   protocol  = "tcp"
   security_group_id = "${var.static_sg}"
   source_security_group_id = "${aws_security_group.applb_sg.id}"
}

#Security group rule for bastion host
resource "aws_security_group_rule" "ssh_access_to_bastion" {
   type = "ingress"
   from_port = 22
   to_port   = 22
   protocol  = "tcp"
   security_group_id = "${aws_security_group.bastion.id}"
   cidr_blocks = ["0.0.0.0/0"]
}

#Bastion access to application and web hosts
resource "aws_security_group_rule" "bastion_egress_to_app" {
   type = "egress"
   from_port = 22
   to_port   = 22
   protocol  = "tcp"
   security_group_id = "${aws_security_group.bastion.id}"
   source_security_group_id = "${var.app_sg}"
}
resource "aws_security_group_rule" "bastion_egress_to_static" {
   type = "egress"
   from_port = 22
   to_port   = 22
   protocol  = "tcp"
   security_group_id = "${aws_security_group.bastion.id}"
   source_security_group_id = "${var.static_sg}"
}

resource "aws_security_group_rule" "ingress_from_bastion_to_app" {
   type = "ingress"
   from_port = 22
   to_port   = 22
   protocol  = "tcp"
   security_group_id = "${var.app_sg}"
   source_security_group_id = "${aws_security_group.bastion.id}"
}
resource "aws_security_group_rule" "ingress_from_bastion_to_static" {
   type = "ingress"
   from_port = 22
   to_port   = 22
   protocol  = "tcp"
   security_group_id = "${var.static_sg}"
   source_security_group_id = "${aws_security_group.bastion.id}"
}


#80 & 443 egress to install packages
resource "aws_security_group_rule" "app_internet_access_80" {
   type = "egress"
   from_port = 80
   to_port   = 80
   protocol  = "tcp"
   security_group_id = "${var.app_sg}"
   cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "app_internet_access_443" {
   type = "egress"
   from_port = 443
   to_port   = 443
   protocol  = "tcp"
   security_group_id = "${var.app_sg}"
   cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "static_internet_access_80" {
   type = "egress"
   from_port = 80
   to_port   = 80
   protocol  = "tcp"
   security_group_id = "${var.static_sg}"
   cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "static_internet_access_443" {
   type = "egress"
   from_port = 443
   to_port   = 443
   protocol  = "tcp"
   security_group_id = "${var.static_sg}"
   cidr_blocks = ["0.0.0.0/0"]
}


