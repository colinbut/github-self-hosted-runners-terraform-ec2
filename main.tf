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

resource "aws_launch_template" "name" {
  name        = "github_runner_launch_template"
  description = "Launch Template for GitHub Runners EC2 AutoScaling Group"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      delete_on_termination = true
      volume_size           = 20
    }
  }

  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = templatefile("${path.cwd}/bootstrap.tmpl", { github_repo_url = var.github_repo_url, github_repo_pat_token = var.github_repo_pat_token, runner_name = var.runner_name, labels = join(",", var.labels) })

  tags = {
    Name = "github_runner"
  }
}