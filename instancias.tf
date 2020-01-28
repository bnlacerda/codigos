
provider "aws" {
    region = "us-east-1"
}


resource "aws_instance" "web" {
    ami = "${var.ami}" 
    instance_type ="${var.type}" 
    key_name = "lac"

    provisioner "file" {
        source = "hello-world.txt"
        destination = "/tmp/file.txt"

        connection {
      
           type = "ssh"
           user = "ec2-user"
           timeout = "2m"
           private_key = "lac.pem" 
           
        }   
    }

    provisioner "remote-exec" {
        inline = [
            "sleep 10",
            "echo \"[UPDATING THE SYSTEM]\"",
            "sudo yum update -y",
            "echo \"[INSTALLING HTTPD]\"",
            "sudo yum install -y httpd",
            "echo \"[START HTTPD]\"", 
            "sudo service httpd start",
            "sudo chkconfig httpd",
            "echo \"[FINISHING]\"",
            "sudo sleep 10",
        ]

        connection {

            host = "${self.ipv4_address}"
            type = "ssh"
            user = "ec2-user"
            timeout = "1m"
            private_key = "${file("lac.pem")}"
        }
    }

}
