resource "aws_launch_template" "lt" {
  name_prefix   = "web-template"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.sg_id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum install nginx -y
              systemctl start nginx
              systemctl enable nginx
              EOF
  )
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity = 2
  max_size         = 3
  min_size         = 1

  vpc_zone_identifier = [var.subnet_id]

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns = [var.tg_arn]
}