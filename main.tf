resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
}

resource "aws_subnet" "subnet" {
  count      = "${length(var.subnet_cidr)}"
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "${element(var.subnet_cidr, count.index)}"
}

resource "aws_security_group" "sg" {
  vpc_id = "${aws_vpc.vpc.id}"
  name   = "${var.sg_name}"
}

resource "aws_security_group_rule" "ingress" {
  count             = "${length(keys(var.ingress_rules))}"
  type              = "ingress"
  from_port         = "${element(split(",", element(keys(var.ingress_rules), count.index)), 1)}"
  protocol          = "${element(split(",", element(keys(var.ingress_rules), count.index)), 0)}"
  to_port           = "${element(split(",", element(keys(var.ingress_rules), count.index)), 2)}"
  cidr_blocks       = "${compact(split(",", element(values(var.ingress_rules), count.index)))}"
  security_group_id = "${aws_security_group.sg.id}"
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  count             = "${length(keys(var.egress_rules))}"
  from_port         = "${element(split(",", element(keys(var.egress_rules), count.index)), 1)}"
  protocol          = "${element(split(",", element(keys(var.egress_rules), count.index)), 0)}"
  to_port           = "${element(split(",", element(keys(var.egress_rules), count.index)), 2)}"
  cidr_blocks       = "${compact(split(",", element(values(var.egress_rules), count.index)))}"
  security_group_id = "${aws_security_group.sg.id}"
}
