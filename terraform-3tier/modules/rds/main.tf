# DB Subnet Group
resource "aws_db_subnet_group" "db_subnet" {
  name       = "db-subnet-group"
  subnet_ids = var.db_subnets

  tags = {
    Name = "DB-Subnet-Group"
  }
}

# RDS Instance
resource "aws_db_instance" "mysql" {
  identifier         = "mydb"
  engine             = "mysql"
  engine_version     = "8.0"
  instance_class     = "db.t3.micro"
  allocated_storage  = 20

  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [var.db_sg]

  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    Name = "MyRDS"
  }
}