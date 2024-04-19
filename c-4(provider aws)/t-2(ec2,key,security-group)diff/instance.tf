resource "aws_instance" "first-instance" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name                    = aws_key_pair.deployer.key_name
  associate_public_ip_address = true
  availability_zone           = "${var.availability_zone}"
  tags = {
    Name = "ExampleInstance"
  }
  security_groups = [aws_security_group.allow_tls.name]
  root_block_device {
    volume_size = 10
  }
  depends_on = [aws_security_group.allow_tls]  
}