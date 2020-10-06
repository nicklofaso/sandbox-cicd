variable "name_prefix" {
    default = "tftrade"
}

variable "project" {
    default = "rational-photon-282814"
}

variable "region" {
    default = "us-east1"
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