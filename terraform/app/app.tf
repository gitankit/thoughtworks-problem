resource "aws_instance" "app" {
   ami = "${var.aws_ami}"
   instance_type = "${var.aws_instance_type}"
   #key_name =
   #vpc_security_group_ids = 
   subnet_id = "${element(var.private_subnets,count.index)}"
   #iam_instance_profile =
   root_block_device {
      volume_type = "gp2"
      volume_size = "20"
   }
   count = "${var.environment == "prod" ? length(var.private_subnets) : 1}"
   
}
