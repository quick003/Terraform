variable users {
    type = list
}

output printlist {
    value = "users are ${join(",", var.users)}"
}

output printupper {
    value = "first user is ${upper(var.users[0])}"
}

output printlower {
    value = "first user is ${lower(var.users[0])}"
}

output printtitle {
    value = "first user is ${title(var.users[0])}"
}

output printzip {
    value = zipmap(["a","b"],[1,2])
}
