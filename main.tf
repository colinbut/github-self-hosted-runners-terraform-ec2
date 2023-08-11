terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region  = "us-east-2"
}


data "aws_ami" "amazon_linux" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = [var.ami_filter_name]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = var.ami_architecture
  }
}


resource "aws_launch_template" "ec2_launch_template" {
  name        = "github_runner_launch_template"
  description = "Launch Template for GitHub Runners EC2 AutoScaling Group"

  image_id               = data.aws_ami.amazon_linux
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.github_runners_sg]
  network_interfaces {
    associate_public_ip_address = false
  }
  instance_market_options {
    market_type = "spot"
  }

  user_data = base64encode(templatefile("${path.cwd}/bootstrap.tmpl", { github_repo_url = var.github_repo_url, github_repo_pat_token = var.github_repo_pat_token, runner_name = var.runner_name, labels = join(",", var.labels) }))

  tags = merge(
    var.tags,
    { Name = var.runner_name },
  )
}

resource "aws_autoscaling_group" "github_runners_autoscaling_group" {
  name                      = "github_runners_autoscaling_group"
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = "EC2"
  health_check_grace_period = var.health_check_grace_period
  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  max_size                  = var.max_size
  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }
}

resource "aws_security_group" "github_runners_sg" {
  name        = "gh_runner_allow_outbound"
  description = "Only allow outbound traffic"
  vpc_id      = var.vpc

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    var.tags,
    { Name = "github_runner_allow_outbound" },
  )
}