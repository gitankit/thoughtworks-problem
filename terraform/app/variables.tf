variable "private_subnets" {
   type = "list"
}

variable "aws_ami" {}

variable "aws_instance_type" {
   default = "t2.micro"
}


variable "environment" {}
variable "project" {}


