provider "aws" {
  region = "us-east-1"
  access_key = "xxxx"
  secret_key = "xxxx"
}

resource "aws_key_pair" "deployer-1" {
  key_name   = "deployer-key"
  public_key = file("${path.module}/key.pub")
}

resource "aws_security_group" "allow_tls-1" {
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

resource "aws_instance" "helo-virginia" {
  ami           = "ami-080e1f13689e07408"
  instance_type = "t2.micro"
  key_name                    = aws_key_pair.deployer-1.key_name
  associate_public_ip_address = true
  availability_zone           = "us-east-1a"
  tags = {
    Name = "ExampleInstance"
  }
  security_groups = [aws_security_group.allow_tls-1.name]
  root_block_device {
    volume_size = 10
  }
  depends_on = [aws_security_group.allow_tls-1]  # Add this line to ensure the instance waits for the security group creation
}

########################

provider "aws" {
  alias      = "us-east-2"
  region = "us-east-2"
  access_key = "xxxx"
  secret_key = "xxxx"
}

resource "aws_key_pair" "deployer-2" {
  provider = aws.us-east-2
  key_name   = "deployer-key"
  public_key = file("${path.module}/key.pub")
}

resource "aws_security_group" "allow_tls-2" {
  provider = aws.us-east-2
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

resource "aws_instance" "helo-ohio" {
  provider = aws.us-east-2
  ami           = "ami-0b4750268a88e78e0"
  instance_type = "t2.micro"
  key_name                    = aws_key_pair.deployer-2.key_name
  associate_public_ip_address = true
  availability_zone           = "us-east-2a"
  tags = {
    Name = "ExampleInstance"
  }
  security_groups = [aws_security_group.allow_tls-2.name]
  root_block_device {
    volume_size = 10
  }
  depends_on = [aws_security_group.allow_tls-2]  # Add this line to ensure the instance waits for the security group creation
}
