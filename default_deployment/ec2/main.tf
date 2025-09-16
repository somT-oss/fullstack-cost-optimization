resource "tls_private_key" "ssh_key" {
    algorithm = "RSA"
    rsa_bits = 4096
}


resource "aws_key_pair" "ssh_key_pair" {
    key_name = "webserver_key"
    public_key = tls_private_key.ssh_key.public_key_openssh

    provisioner "local-exec" {
        command = "echo '${tls_private_key.ssh_key.private_key_pem}' > ./webserver.pem"
    }
}


resource "aws_instance" "webserver" {
    ami = var.instance_ami
    instance_type = var.instance_type
    associate_public_ip_address = true
    subnet_id = var.private_subnet_id
    vpc_security_group_ids = [var.books_ec2_sg_id]
    key_name = aws_key_pair.ssh_key_pair.key_name

    credit_specification {
        cpu_credits = "standard"
    }

    tags = {
      Name = "webserver1"
    }

    user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    EOF
}