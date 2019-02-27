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

#module "static_web" {
#   source = "./static"
#   vpc_id = "${module.vpc.vpc_id}"
#   private_subnets = "${module.vpc.private_subnets}"
#   project = "${var.project}"
#   environment = "${var.environment}"
#   aws_ami = "${var.aws_ami}"
#}

module "application" {
   source = "./app"
   vpc_id = "${module.vpc.vpc_id}"
   #public_subnets = "${module.vpc.public_subnets}"
   private_subnets = "${module.vpc.private_subnets}"
   project = "${var.project}"
   environment = "${var.environment}"
   aws_ami = "${var.aws_ami}"
   aws_pub_key = "${var.aws_public_key_name}"
}

module "common" {
   source = "./common"
   aws_key_name = "${var.aws_public_key_name}"
}
