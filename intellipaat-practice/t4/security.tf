resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.example_vpc.id

  dynamic "ingress" {
    for_each = var.porta
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
