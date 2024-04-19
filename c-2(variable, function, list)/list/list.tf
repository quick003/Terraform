variable users {
    type = list
}

output printlist1 {
    value = "first user is ${var.users[0]}"
}

output printlist2 {
    value = "second user is ${var.users[1]}"
}

output printlist3 {
    value = "third user is ${var.users[2]}"
}