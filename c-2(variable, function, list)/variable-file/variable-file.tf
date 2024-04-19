variable "username" {
  type = string
}

variable "userage" {
  type = number
}

output "print" {
  value = "hello, ${var.username}, your age is ${var.userage}"
}