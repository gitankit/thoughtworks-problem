#Using provider as AWS
provider "aws" {
   access_key = "${var.aws_access_key}" 
   secret_key = "${var.aws_secret_key}"
   region     = "${var.aws_region}"
}

#Azs
data "aws_availability_zones" "available" {}

#Create az_count number of subnets or default 2(Load balancer needs min 2 subnets). You can change the default here.
#This is mainly for controlling subnets creation. For instances you can set your own number.
locals {
   az_count = "${var.environment == "prod" ? length(data.aws_availability_zones.available.names) : 2}"
}


#VPC module
module "vpc" {
   source = "./vpc"
   project = "${var.project}"
   environment = "${var.environment}"
   az_count = "${local.az_count}"
}

#Static data instances.
module "static" {
   source = "./static"
   vpc_id = "${module.vpc.vpc_id}"
   private_subnets = "${module.vpc.private_subnets}"
   project = "${var.project}"
   environment = "${var.environment}"
   aws_ami = "${var.aws_ami}"
   aws_pub_key = "${var.aws_public_key_name}"
   #By default set to az_count but user specified instances can be specified.
   #To scale up the number of static instances increase this number or decrease for scaling down.
   az_count = "${local.az_count}"
   elb_sg = "${module.common.elb_sg}"
   bastion_ip = "${module.common.bastion_public_ip}"
}

#Dynamic application instances
module "application" {
   source = "./app"
   vpc_id = "${module.vpc.vpc_id}"
   private_subnets = "${module.vpc.private_subnets}"
   project = "${var.project}"
   environment = "${var.environment}"
   aws_ami = "${var.aws_ami}"
   aws_pub_key = "${var.aws_public_key_name}"
   #By default set to az_count but user specified instances can be specified.
   #To scale up the number of application instances increase this number or decrease for scaling down.
   az_count = "${local.az_count}"
   elb_sg = "${module.common.elb_sg}"
   bastion_ip = "${module.common.bastion_public_ip}"
}

#Common components.
#Bastion Instance.
#Load balancer
#SSL Certificate
#SSH key pairs
module "common" {
   source = "./common"
   aws_key_name = "${var.aws_public_key_name}"
   public_subnets = "${module.vpc.public_subnets}"
   project = "${var.project}"
   environment = "${var.environment}"
   app_sg = "${module.application.sg_id}"
   static_sg = "${module.static.sg_id}"
   vpc_id = "${module.vpc.vpc_id}"
   app_instance_ids = ["${module.application.app_instance_ids}"]
   static_instance_ids = ["${module.static.static_instance_ids}"]
   az_count = "${local.az_count}"
   app_sg = "${module.application.sg_id}"
   static_sg = "${module.static.sg_id}"
   aws_ami = "${var.aws_ami}"
   aws_pub_key = "${var.aws_public_key_name}"

}
