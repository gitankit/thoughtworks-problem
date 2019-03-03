#Creates an AWS application load balancer
resource "aws_lb" "applb" {
  name               = "companynews"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.applb_sg.id}"]
  #subnets            = ["${aws_subnet.public.*.id}"]
  subnets            = ["${var.public_subnets}"]

  enable_deletion_protection = false


  tags = {
    Environment = "${var.environment}"
    Project = "${var.project}"
  }
}


#Create 2 target groups for application and static seperately.
#Requests will be routed based on path to these target groups.

#Application target group.
resource "aws_lb_target_group" "app_tg" {
  name     = "application"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
  target_type = "instance"
  health_check {
    interval = 10
    port = "traffic-port"
    protocol = "HTTP"
    path = "/companyNews/"
    matcher = "200"
  }
}

#Static instances target group.
resource "aws_lb_target_group" "static_tg" {
  name     = "static"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
  target_type = "instance"
  health_check {
    interval = 10
    port = "traffic-port"
    protocol = "HTTP"
    path = "/companyNews/styles/company.css"
    matcher = "200"
  }
}

#Attach application instances to app target group.
resource "aws_lb_target_group_attachment" "app" {
  target_group_arn = "${aws_lb_target_group.app_tg.arn}"
  target_id        = "${element(var.app_instance_ids,count.index)}"
  port             = 8080
  count            = "${var.az_count}"
}	

#Attach static instances to static target group.
resource "aws_lb_target_group_attachment" "static" {
  target_group_arn = "${aws_lb_target_group.static_tg.arn}"
  target_id        = "${element(var.static_instance_ids,count.index)}"
  port             = 8080
  count            = "${var.az_count}"
}

#Attach an SSL listener to load balancer.
resource "aws_lb_listener" "application" {
  load_balancer_arn = "${aws_lb.applb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${aws_acm_certificate.companynews.arn}"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.app_tg.arn}"
  }
}

#Add listener rule for static target group.One rule per block.
#This one for images.
resource "aws_lb_listener_rule" "static_images" {
  listener_arn = "${aws_lb_listener.application.arn}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.static_tg.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["/companyNews/images/*"]
  }
}

#This one for styles.
resource "aws_lb_listener_rule" "static_styles" {
  listener_arn = "${aws_lb_listener.application.arn}"
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.static_tg.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["/companyNews/styles/*"]
  }
}



output "elb_sg" {
   value = "${aws_security_group.applb_sg.id}"
}

output "elb_dns_endpoint" {
   value = "${aws_lb.applb.dns_name}"
}
