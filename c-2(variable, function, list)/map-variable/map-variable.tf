variable "userage" {
  type = map
  default = {
    ritik = 24
    ritu = 25
  }
}

variable username {
    type = string
}

output printmap {
    value = "my name is ritik & my ge is ${lookup(var.userage, "ritik")}"
}

output printmaptake {
    value = "my name is ${var.username} & my ge is ${lookup(var.userage, "${var.username}")}"
}