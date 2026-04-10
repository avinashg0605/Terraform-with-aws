resource "aws_security_group" "this" {
  name   = var.sg_name
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port = ingress.value.from_port
      to_port   = ingress.value.from_port
      protocol  = "tcp"

      cidr_blocks     = lookup(ingress.value, "cidr_blocks", null)
      security_groups = lookup(ingress.value, "security_groups", null)
    }
  }
}