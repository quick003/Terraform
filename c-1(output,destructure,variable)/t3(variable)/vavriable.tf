variable username {
    default = "world"
}

variable age {
    type=number
}

output printname {
    value=var.username
}

output printage {
    value=var.age
}

output print {
    value="hello ${var.username} ur age is ${var.age}"
}
