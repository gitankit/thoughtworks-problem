
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

  provisioner "remote-exec" {
      inline = [
         "wget http://mirrors.estointernet.in/apache/tomcat/tomcat-8/v8.5.38/bin/apache-tomcat-8.5.38.tar.gz" ,
         "tar -xzf apache-tomcat-8.5.38.tar.gz" ,
         "sudo mv apache-tomcat-8.5.38 /opt/" ,
         "sudo /opt/apache-tomcat-8.5.38/bin/catalina.sh start"]
  }

  connection {
     type = "ssh"
     user = "ec2-user"
     private_key = "${file("${path.root}/keys/priv.key")}"
     port = 22
     host = "${self.private_ip}"
     bastion_host = "${var.bastion_ip}"
     
  }

}

output "app_instance_ids" {
   value = ["${aws_instance.app.*.id}"]
}

output "app_private_ips" {
   value = ["${aws_instance.app.*.private_ip}"]
}
