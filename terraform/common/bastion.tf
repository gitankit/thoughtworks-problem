resource "aws_instance" "bastion" {
   ami = "${var.aws_ami}"
   instance_type = "${var.aws_instance_type}"
   key_name = "${var.aws_pub_key}"
   vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
   #Always create bastion host in public subnet.At least 1 public subnet will be created.
   subnet_id = "${element(var.public_subnets,0)}"
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

#Elastic ip address for bastion host.
resource "aws_eip" "bastion_eip" {
  vpc  = true
}

resource "aws_eip_association" "bastion_eip_assoc" {
  instance_id   = "${aws_instance.bastion.id}"
  allocation_id = "${aws_eip.bastion_eip.id}"
}

#Copying private key to bastion host for manual debugging.
#This is used when logging on to instances from bastion.
resource "null_resource" "bastion_access" {
  provisioner "file" {
      source = "${path.root}/keys/priv.key"
      destination = "/home/ec2-user/.ssh/id_rsa"
  }

  provisioner "remote-exec" {
      inline = ["chmod 600 /home/ec2-user/.ssh/id_rsa"]
  }

  connection {
     type = "ssh"
     user = "ec2-user"
     private_key = "${file("${path.root}/keys/priv.key")}"
     port = 22
     host = "${aws_eip.bastion_eip.public_ip}"
     
  }

}

output "bastion_public_ip" {
   value = "${aws_instance.bastion.public_ip}"
}

