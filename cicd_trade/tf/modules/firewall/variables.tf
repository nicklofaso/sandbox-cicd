variable "name_prefix" {
  type = string
}

variable "project" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "network" {
  type = string
}
