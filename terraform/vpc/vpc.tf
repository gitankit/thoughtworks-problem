resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_block}"
  enable_dns_support = true
  enable_dns_hostanme = true


  tags = {
    Environment = "${var.environment}"
    Project = "{$var.project}"
    Name = "${var.project}"
  }
}

#Azs
data "aws_availability_zones" "available" {
   status = available
}


#Create public subnets
resource "aws_subnet" "public-${count.index}" {
   vpc_id = "${aws_vpc.vpc.id}"
   count = "${var.environment == "prod" ? length(data.aws_availability_zones.available) : 1}"
   availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
   cidr_block = "${var.cidr_public_subnet[count.index]}"
}





