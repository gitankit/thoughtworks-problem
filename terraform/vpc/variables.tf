variable "cidr_block" {
   type = "string"
   default = "10.0.0.0/16"
}

variable "cidr_public_subnet" {
   type = "list"
   default = ["10.1.0.0/24" , "10.2.0.0/24" , "10.3.0.0/24" , "10.4.0.0/24" , "10.5.0.0/24"]
}

variable "cidr_private_subnet" {
   type = "list"
   default = ["10.11.0.0/24" , "10.12.0.0/24" , "10.13.0.0/24", "10.14.0.0/24", "10.15.0.0/24"]
}

variable "project" {}

variable "environment" {}
