variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "project_name" {
  description = "Project name used for tagging"
  type        = string
}

variable "availability_zone" {
  description = "List of availability zones"
  type        = list(string)
}

variable "cidr_block" {
  description = "CIDR blocks for subnets (2 public + 2 private)"
  type        = list(string)
}