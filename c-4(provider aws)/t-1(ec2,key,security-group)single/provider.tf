provider "aws" {
  region     = "us-east-1"
  access_key = "###"
  secret_key = "###"
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
  key_name                    = aws_key_pair.deployer.key_name
  # security_groups             = [aws_security_group.allow_tls.id]
  associate_public_ip_address = true
  availability_zone           = "us-east-1a"
  tags = {
    Name = "ExampleInstance"
  }
  security_groups = [aws_security_group.allow_tls.name]
  root_block_device {
    volume_size = 10
  }
  depends_on = [aws_security_group.allow_tls]  # Add this line to ensure the instance waits for the security group creation
}

output "ec2instance" {
  value = aws_security_group.allow_tls.id
}