variable "ami" {}
variable "instance_type" {}
variable "subnets" {
  type = list(string)
}
variable "sg_id" {}
variable "target_group_arn" {}
variable "key_name" {}
variable "user_data" {}