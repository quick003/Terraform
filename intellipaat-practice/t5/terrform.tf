provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("${path.module}/key.pub")
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"

  dynamic "ingress" {
    for_each = [22, 80, 443, 3306]
    iterator = port
    content {
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = port.value
      to_port     = port.value
      description = "allow port"
    }
  }

}

resource "aws_instance" "first-instance" {
  ami           = "ami-0cd59ecaf368e5ccf"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.allow_tls.name]
  associate_public_ip_address = true
  availability_zone           = "us-east-1a"
  tags = {
    Name = "ExampleInstance"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/key")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh > /tmp/script.log 2>&1"
    ]
  }

  provisioner "local-exec" {
    command = "echo '${self.private_ip}' > ip_address.txt"
  }

  depends_on = [aws_security_group.allow_tls]
}


output "instance_ip" {
  value = aws_instance.first-instance.public_ip
}