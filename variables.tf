variable "vpc_cidr" {
  type = "string"
}

variable "subnet_cidr" {
  type = "list"
}

variable "sg_name" {
  type = "string"
}

variable "ingress_rules" {
  type = "map"
}

variable "egress_rules" {
  type = "map"
  default = {
    "-1,0,0" = "0.0.0.0/0"
  }
}
