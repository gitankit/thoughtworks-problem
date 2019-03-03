#Create static instances.Count number of instances will be created.
#Set count to custom value to change the number of instances created.

resource "aws_instance" "static" {
   ami = "${var.aws_ami}"
   instance_type = "${var.aws_instance_type}"
   key_name = "${var.aws_pub_key}"
   vpc_security_group_ids = ["${aws_security_group.static.id}"]
   subnet_id = "${element(var.private_subnets,count.index)}"
   root_block_device {
      volume_type = "gp2"
      volume_size = "20"
   }
   #Change the variable az_count for number of instances.
   count = "${var.instances_count}"

   tags {
      Name = "${format("Static-%01d" , count.index + 1)}"
   }

  #Setup tomcat to just deliver static content
  provisioner "remote-exec" {
      inline = [
         "wget http://mirrors.estointernet.in/apache/tomcat/tomcat-8/v8.5.38/bin/apache-tomcat-8.5.38.tar.gz" ,
         "tar -xzf apache-tomcat-8.5.38.tar.gz" ,
         "sudo mv apache-tomcat-8.5.38 /opt/" ,
         "sudo mkdir -p /opt/apache-tomcat-8.5.38/static/images/" ,
         "sudo mkdir -p /opt/apache-tomcat-8.5.38/static/styles/" ,
         "sudo chown ec2-user:ec2-user -R /opt/apache-tomcat-8.5.38" ,
         "rm -rf /opt/apache-tomcat-8.5.38/webapps/*"
      ]
  }

  #Copy the static conf file
  provisioner "file" {
      source = "${path.root}/confs/static/server.xml"
      destination = "/opt/apache-tomcat-8.5.38/conf/server.xml"
  }

  #Copy images
  provisioner "file" {
      source = "${path.root}/artifacts/static/images/logo.png"
      destination = "/opt/apache-tomcat-8.5.38/static/images/logo.png"
  }

  #Copy styles
  provisioner "file" {
      source = "${path.root}/artifacts/static/styles/company.css"
      destination = "/opt/apache-tomcat-8.5.38/static/styles/company.css"
  }

  #Start tomcat
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

output "static_instance_ids" {
   value = ["${aws_instance.static.*.id}"]
}


output "static_private_ips" {
   value = ["${aws_instance.static.*.private_ip}"]
}
