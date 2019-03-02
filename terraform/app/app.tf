
resource "aws_instance" "app" {
   ami = "${var.aws_ami}"
   instance_type = "${var.aws_instance_type}"
   key_name = "${var.aws_pub_key}"
   vpc_security_group_ids = ["${aws_security_group.app.id}"]
   subnet_id = "${element(var.private_subnets,count.index)}"
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
         "sudo chown ec2-user:ec2-user -R /opt/apache-tomcat-8.5.38" ,
         "rm -rf /opt/apache-tomcat-8.5.38/webapps/*"
     ]
  }
  provisioner "file" {
      source = "${path.root}/confs/app/server.xml"
      destination = "/opt/apache-tomcat-8.5.38/conf/server.xml"
  }

  provisioner "file" {
      source = "${path.root}/artifacts/companyNews.war"
      destination = "/opt/apache-tomcat-8.5.38/webapps/companyNews.war"
  }

  provisioner "remote-exec" {
      inline = ["sudo nohup /opt/apache-tomcat-8.5.38/bin/catalina.sh start" , "sleep 20"]
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
