variable "aws_access_key" {
   type = "string"
}

variable "aws_secret_key" {
   type = "string"
}

variable "aws_region" {
   type = "string"
}

#Global variables

variable "project" {
   type = "string"
   default = "default-app"
}

variable "environment" {
   type = "string"
   #default = "stage"
   default = "stage"
}

variable "aws_ami" {
   default = "ami-0cd3dfa4e37921605"
}

variable "aws_public_key_name" {
   default = "instance_key"
}


output "dns_name_application" {
   value = "https://${module.common.elb_dns_endpoint}/companyNews"
}

output "bastion_ip_address" {
   value = "${module.common.bastion_public_ip}"
}





