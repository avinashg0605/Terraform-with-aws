resource "tls_private_key" "generated" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "bastion"
  public_key = tls_private_key.generated.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.generated.private_key_pem
  filename = "bastion.pem"
}


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

module "bastion" {
  source = "./modules/ec2"

  ami           = "ami-0ea87431b78a82070"   # Amazon Linux (update later)
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnets[0]
  sg_id         = module.sg.bastion_sg
  key_name      = aws_key_pair.key_pair.key_name
}

module "alb" {
  source = "./modules/alb"

  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  alb_sg          = module.sg.alb_sg
}

module "asg" {
  source = "./modules/asg"

  ami               = "ami-0ea87431b78a82070"   # Update later
  instance_type     = "t2.micro"
  subnets           = module.vpc.private_subnets
  sg_id             = module.sg.web_sg
  target_group_arn  = module.alb.web_target_group_arn
  key_name          = aws_key_pair.key_pair.key_name
}
module "app_asg" {
  source = "./modules/asg"

  ami               = "ami-0ea87431b78a82070"
  instance_type     = "t2.micro"
  subnets           = module.vpc.private_subnets
  sg_id             = module.sg.app_sg
  target_group_arn  = module.alb.app_target_group_arn
  key_name          = aws_key_pair.key_pair.key_name
}