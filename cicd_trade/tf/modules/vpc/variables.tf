variable "name_prefix" {
  type = string
}

variable "project" {
  type = string
}

variable "regions" {
  type = list(string)
}

variable "cidr_block" {
  type = string
}

variable "cidr_subnetwork_width_delta" {
  type = number
}

variable "cidr_subnetwork_spacing" {
  type = number
}
