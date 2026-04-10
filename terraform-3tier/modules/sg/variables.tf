variable "vpc_id" {
  type = string
}
variable "sg_name" {
  type = string
}
variable "ingress_rules" {
  type = list(object({
    from_port       = number
    cidr_blocks     = optional(list(string))
    security_groups = optional(list(string))
  }))
}