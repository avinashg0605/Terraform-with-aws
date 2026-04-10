# resource "tls_private_key" "generated" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "key_pair" {
#   key_name   = "Hr_manager_bastion"
#   public_key = tls_private_key.generated.public_key_openssh
# }

# resource "local_file" "private_key" {
#   content  = tls_private_key.generated.private_key_pem
#   filename = "Hr_manager_bastion.pem"
# }

# module "vpc" {
#   source = "./modules/vpc"
#   vpc_cidr = "10.0.0.0/16"
#   project_name = "hr_vpc"
#   availability_zone = [ "us-east-1a","us-east-1b" ]
#   cidr_block = [ "10.0.1.0/24","10.0.2.0/24","10.0.3.0/24","10.0.4.0/24"]
# }

# module "bastion_sg" {
#   source = "./modules/sg"

#   sg_name = "bastion_sg"
#   vpc_id  = module.vpc.vpc_id

#   ingress_rules = [
#     {
#       from_port   = 22
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   ]
# }
# module "alb_sg" {
#   source = "./modules/sg"

#   sg_name = "alb_sg"
#   vpc_id  = module.vpc.vpc_id

#   ingress_rules = [
#     {
#       from_port   = 80
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   ]
# }

# module "web_sg" {
#   source = "./modules/sg"

#   sg_name = "web_sg"
#   vpc_id  = module.vpc.vpc_id

#   ingress_rules = [
#     {
#       from_port       = 80
#       security_groups = [module.alb_sg.id]
#     }
#   ]
# }

# module "app_sg" {
#   source = "./modules/sg"

#   sg_name = "app_sg"
#   vpc_id  = module.vpc.vpc_id

#   ingress_rules = [
#     {
#       from_port       = 8080
#       security_groups = [module.web_sg.id]
#     }
#   ]
# }

# module "bastion_server" {
#   source = "./modules/ec2"
  
#   key_name = aws_key_pair.key_pair.key_name
#   subnet_id = module.vpc.public_subnets[0].id
#   # ami_id =  var.instance_config.ami_id
#   ami_id ="ami-0ea87431b78a82070"
#   # instance_ebs_volume = var.instance_config.ebs_volume_size
#   instance_ebs_volume = 8
#   # instance_type = var.instance_config.instance_type
#   instance_type = "t2.micro"
#   security_group_ids = [module.bastion_sg.id]
#   project_name = "hr_manager"


 
# }

# module "web_servers" {
#   source = "./modules/ec2"

#   for_each = {
#     web1 = {
#       ami_id          = "ami-0ea87431b78a82070"
#       instance_type   = "t2.micro"
#       ebs_volume_size = 8
#       subnet_index    = 0
#     }

#     web2 = {
#       ami_id          = "ami-0ea87431b78a82070"
#       instance_type   = "t2.micro"
#       ebs_volume_size = 8
#       subnet_index    = 1
#     }
#   }

#   key_name = aws_key_pair.key_pair.key_name

#   subnet_id = module.vpc.private_subnets[each.value.subnet_index].id

#   ami_id              = each.value.ami_id
#   instance_ebs_volume = each.value.ebs_volume_size
#   instance_type       = each.value.instance_type

#   security_group_ids = [module.web_sg.id]

#   project_name = "web-${each.key}"
# }

# module "app_servers" {
#   source = "./modules/ec2"

#   for_each = {
#     web1 = {
#       ami_id          = "ami-0ea87431b78a82070"
#       instance_type   = "t2.micro"
#       ebs_volume_size = 8
#       subnet_index    = 0
#     }

#     web2 = {
#       ami_id          = "ami-0ea87431b78a82070"
#       instance_type   = "t2.micro"
#       ebs_volume_size = 8
#       subnet_index    = 1
#     }
#   }

#   key_name = aws_key_pair.key_pair.key_name

#   subnet_id = module.vpc.private_subnets[each.value.subnet_index].id

#   ami_id              = each.value.ami_id
#   instance_ebs_volume = each.value.ebs_volume_size
#   instance_type       = each.value.instance_type

#   security_group_ids = [module.web_sg.id]

#   project_name = "web-${each.key}"
# }


# ----------------------------------------------------------------------------------

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  db_subnets      = ["10.0.5.0/24", "10.0.6.0/24"]
  azs             = ["us-east-1a", "us-east-1b"]
}

module "sg" {
  source = "./modules/security-groups"

  vpc_id = module.vpc.vpc_id
}