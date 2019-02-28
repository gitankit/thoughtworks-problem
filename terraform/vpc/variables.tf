variable "cidr_block" {
   type = "string"
   default = "10.0.0.0/16"
}

variable "cidr_public_subnet" {
   type = "list"
   default = ["10.0.11.0/24" , "10.0.12.0/24" , "10.0.13.0/24" , "10.0.14.0/24" , "10.0.15.0/24"]
}

variable "cidr_private_subnet" {
   type = "list"
   default = ["10.0.16.0/24" , "10.0.17.0/24" , "10.0.19.0/24", "10.0.19.0/24", "10.0.20.0/24"]
}

variable "project" {}

variable "environment" {}

variable "az_count" {}

variable "az_names" {
   type = "list"
}


