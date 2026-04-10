variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "db_subnets" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "ami" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_name" {
  type = string
}
variable "key_name" {}

variable "db_username" {}

variable "db_password" {
  sensitive = true
}