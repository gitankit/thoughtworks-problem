resource "aws_instance" "bastion" {
   ami = "${var.aws_ami}"
   instance_type = "${var.aws_instance_type}"
   key_name = "${var.aws_pub_key}"
   vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
   subnet_id = "${element(var.public_subnets,0)}"
   #iam_instance_profile =
   root_block_device {
      volume_type = "gp2"
      volume_size = "20"
   }

   tags {
      Name = "bastion"
   }
}


resource "aws_security_group" "bastion" {
   name = "bastion"
   description = "Used as bastion host"
   vpc_id = "${var.vpc_id}"
}


resource "aws_eip" "bastion_eip" {
  vpc  = true
}

resource "aws_eip_association" "bastion_eip_assoc" {
  instance_id   = "${aws_instance.bastion.id}"
  allocation_id = "${aws_eip.bastion_eip.id}"
}

output "bastion_public_ip" {
   value = "${aws_instance.bastion.public_ip}"
}

