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
   default = "stage"
}


