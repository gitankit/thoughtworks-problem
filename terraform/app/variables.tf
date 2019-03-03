variable "private_subnets" {
   type = "list"
}

variable "aws_ami" {}

variable "aws_instance_type" {
   default = "t2.micro"
}

variable "aws_pub_key" {}
variable "vpc_id" {}
variable "environment" {}
variable "project" {}
variable "instances_count" {}
variable "elb_sg" {}
variable "bastion_ip" {}
