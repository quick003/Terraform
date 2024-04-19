provider "aws" {
  region     = "us-east-1"
  access_key = "###"
  secret_key = "###"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("${path.module}/key.pub")
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

# Create two subnets
resource "aws_subnet" "example" {
  count = 2

  cidr_block = "10.0.${count.index + 1}.0/24"
  vpc_id     = aws_vpc.example.id
}

# Create a security group
resource "aws_security_group" "example" {
  name        = "example"
  description = "Example security group"
  vpc_id      = aws_vpc.example.id

  # Allow HTTP traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

# Create two network interfaces
resource "aws_network_interface" "example" {
  count = 2

  subnet_id       = aws_subnet.example[count.index].id
  private_ips     = ["10.0.${count.index + 1}.100"]
  security_groups = [aws_security_group.example.id]
}

# Create two instances with the specified network interfaces
resource "aws_instance" "example" {
  count = 2

  ami           = "ami-0cd59ecaf368e5ccf" # Ubuntu AMI
  instance_type = "t2.micro"

  network_interface {
    device_index          = 0
    network_interface_id  = aws_network_interface.example[count.index].id
    delete_on_termination = false
  }

  # Install Apache2
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y apache2
              sudo systemctl start apache2
              sudo systemctl enable apache2
              EOF

  # Key for the instance
  key_name = aws_key_pair.deployer.key_name
}

# Output the public IP addresses of the instances
output "public_ips" {
  value = aws_instance.example.*.public_ip
}