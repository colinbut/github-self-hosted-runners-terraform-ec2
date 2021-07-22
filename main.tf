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
  profile = "default"
  region  = "eu-west-2"
}


data "aws_availability_zones" "all_azs" {
  state = "available"
}


resource "aws_launch_template" "ec2_launch_template" {
  name        = "github_runner_launch_template"
  description = "Launch Template for GitHub Runners EC2 AutoScaling Group"

  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = base64encode(templatefile("${path.cwd}/bootstrap.tmpl", { github_repo_url = var.github_repo_url, github_repo_pat_token = var.github_repo_pat_token, runner_name = var.runner_name, labels = join(",", var.labels) }))

  tags = {
    Name = "github_runner"
  }
}

resource "aws_autoscaling_group" "github_runners_autoscaling_group" {
  name                      = "github_runners_autoscaling_group"
  availability_zones        = data.aws_availability_zones.all_azs.names
  health_check_type         = "EC2"
  health_check_grace_period = 600
  desired_capacity          = 3
  min_size                  = 1
  max_size                  = 4
  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }
}