variable "region" {
  type = string
}

variable "zones" {
  type    = list(string)
  default = ["a", "b", "c", "d", "e", "f"]
}

variable "vpc_cidr_block" {
  type = string
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "tags-sufix" {
  type = string
}

variable "public_subnet_cidr_blocks" {
  type = list(string)
}

variable "private_subnet_cidr_blocks" {
  type = list(string)
}

variable "use_nat" {
  type = bool
}
