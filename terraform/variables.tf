#AWS Credentials. $$$$$$ DO NOT DEFINE HERE $$$$$$
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

##Changes the environment. Stage will create 2 static & app instances.

##Prod will create static & app instances equal to the number of 
#availability zones in the region.

##Subnets will be created equal to the number of availability zones
#irrespective of any setting.

#Can be changed in specific module blocks.

variable "environment" {
   type = "string"
   #Allowed values = stage , prod
   default = "stage"
}

#Default ami = amazon linux 2018.03
#This change will change the value globally.
#For specific module ami changes , change it in module blocks.
variable "aws_ami" {
   default = "ami-0cd3dfa4e37921605"
}

variable "aws_public_key_name" {
   default = "instance_key"
}


#Do not change
output "dns_name_application" {
   value = "https://${module.common.elb_dns_endpoint}/companyNews"
}

output "bastion_ip_address" {
   value = "${module.common.bastion_public_ip}"
}





