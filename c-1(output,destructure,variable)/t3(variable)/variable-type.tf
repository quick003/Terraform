variable username {
    type = string
}

variable age {
    type = number
}

output printname {
    value= "hello, ${var.username} ur age is ${var.age}"
}