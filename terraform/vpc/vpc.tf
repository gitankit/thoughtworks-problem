resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_block}"
  enable_dns_support = true
  enable_dns_hostnames = true


  tags = {
    Environment = "${var.environment}"
    Project = "${var.project}"
    Name = "${var.project}"
  }
}

#Azs
data "aws_availability_zones" "available" {}




#Create public subnets
resource "aws_subnet" "public" {
   vpc_id = "${aws_vpc.vpc.id}"
   count = "${var.environment == "prod" ? length(data.aws_availability_zones.available.names) : 1}"
   availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
   cidr_block = "${var.cidr_public_subnet[count.index]}"
   tags = {
      Name = "${format("public-%01d" , count.index + 1)}"
   }
}

#Create private subnets
resource "aws_subnet" "private" {
   vpc_id = "${aws_vpc.vpc.id}"
   count = "${var.environment == "prod" ? length(data.aws_availability_zones.available.names) : 1}"
   availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
   cidr_block = "${var.cidr_private_subnet[count.index]}"
   tags = {
      Name = "${format("private-%01d" , count.index + 1)}"
   }
}


#internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "igw"
  }
}


#eip for nat gateway
resource "aws_eip" "natg_eip" {
  vpc  = true
  depends_on = ["aws_internet_gateway.igw"]
}


#nat gateway
resource "aws_nat_gateway" "natgw" {
  allocation_id = "${aws_eip.natg_eip.id}"
   #Always at least one public subnet will be created.
  subnet_id     = "${element(aws_subnet.public.*.id, 0)}"

  tags = {
    Name = "NAT Gw"
  }
}

#Create route table for public subnets and add igw
resource "aws_route_table" "public" {
   vpc_id = "${aws_vpc.vpc.id}"
   route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.igw.id}"
   }
}

#Create route table for private subnets and add natgw
resource "aws_route_table" "private" {
   vpc_id = "${aws_vpc.vpc.id}"
   route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_nat_gateway.natgw.id}"
   }
}

#Associate public subnets
resource "aws_route_table_association" "public_associations" {
  count = "${var.environment == "prod" ? length(data.aws_availability_zones.available.names) : 1}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

#Associate private subnets
resource "aws_route_table_association" "private_associations" {
  count = "${var.environment == "prod" ? length(data.aws_availability_zones.available.names) : 1}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}





