variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name for SSH"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for EC2 (private subnet)"
  type        = string
}

variable "security_group_ids" {
  description = "Security group ID for EC2"
  type        = string
}

variable "instance_ebs_volume" {
  description = "Server EBS volume"
  type = number
}
variable "project_name" {
  type = string
}
