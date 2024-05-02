variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "region" {
  type = string
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "porta" {
  type = list(number)
}