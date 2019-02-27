#Using provider as AWS
provider "aws" {
   access_key = "${var.aws_access_key}" 
   secret_key = "${var.aws_secret_key}"
   region     = "${var.aws_region}"
}

#VPC module
module "vpc" {
   source = "./vpc"
   project = "${var.project}"
   environment = "${var.environment}"
}

module "static_web" {
   source = "./static"
   private_subnets = "${module.vpc.private_subnets}"
   project = "${var.project}"
   environment = "${var.environment}"
   aws_ami = "${var.aws_ami}"
}

module "application" {
   source = "./app"
   #public_subnets = "${module.vpc.public_subnets}"
   private_subnets = "${module.vpc.private_subnets}"
   project = "${var.project}"
   environment = "${var.environment}"
   aws_ami = "${var.aws_ami}"
}


