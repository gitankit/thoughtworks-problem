resource "aws_vpc" "${var.project}_vpc" {
  cidr_block = "${var.cidr_block}"
  enable_dns_support = true
  enable_dns_hostanme = true


  tags = {
    Environment = "${var.environment}"
    Project = "{$var.project}"
  }
}

#Azs
data "aws_availability_zones" "available" {}


resource "aws_subnet" "public-${count.index}" {
   availability_zone = "${data.aws_availability_zones.available.names[0]}"

