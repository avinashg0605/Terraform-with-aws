provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "aami-0ea87431b78a82070" # Amazon Linux (Mumbai)
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform-First-Server"
  }
}