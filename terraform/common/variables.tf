variable "aws_key_name" {}

variable "public_subnets" {
   type = "list"
}

variable "environment" {}
variable "project" {}

variable "app_sg" {}
variable "static_sg" {}
variable "vpc_id" {}

variable "app_instance_ids" { 
   type = "list"
}

variable "static_instance_ids" { 
   type = "list"
}


variable "az_count" {}

variable "aws_ami" {}

variable "aws_instance_type" {
   default = "t2.micro"
}

variable "aws_pub_key" {}

