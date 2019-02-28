
resource "aws_instance" "app" {
   ami = "${var.aws_ami}"
   instance_type = "${var.aws_instance_type}"
   key_name = "${var.aws_pub_key}"
   vpc_security_group_ids = ["${aws_security_group.app.id}"]
   subnet_id = "${element(var.private_subnets,count.index)}"
   #iam_instance_profile =
   root_block_device {
      volume_type = "gp2"
      volume_size = "20"
   }
   #count = "${var.environment == "prod" ? length(data.aws_availability_zones.available.names) : 1}"
   count = "${var.az_count}"

   tags {
      Name = "${format("App-%01d" , count.index + 1)}"
   }
}

output "app_instance_ids" {
   value = ["${aws_instance.app.*.id}"]
}


