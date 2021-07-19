# Github Self-Hosted Runners (Terraform) (EC2)

This is a Terraform repository that contains Terraform code to spin up an EC2 Instance acting as the GitHub Self Hosted Runner for a particular GitHub Repository.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

The Terraform code expects arguments to be passed in to the variable parameters as there are no defaults set enabling the user of this particular GitHub Repository to configure it accordingly to their needs.

`locals.auto.tfvars` is ignored in the `.gitignore` so you can treat that variable file as your local variable file containing all of the required variables arguments.

An example `locals.auto.tfvars` is given below:

```hcl
ami                   = "ami-03ac5a9b225e99b02" # Amazon Linux 2 AMI for eu-west-2 (London)
instance_type         = "t2.micro"
key_name              = # your KeyPair name
github_repo_pat_token = # The GitHub Repository's Pat Token for which you want to register GitHub Runners with to authenticate
github_repo_url       = "https://github.com/{owner}/{repo}"
runner_name           = "gitHub-repo-runner"
labels                = ["dev", "ui", "frontend"]
```

where owner and repo represents the GitHub Account Owner & Repository respectively.

## Information

### VPC
Note that by design not launching the EC2 Auto Scaling Group in a VPC simply because i want this GitHub Runners project to contain an independent GitHub Runner that can be launched directly into any VPC if needed. Since after all the aim of this Repository Project is to demonstrate the construction of GitHub Self Hosted Runners on EC2 instances.

As a result, this project enables the spinning up of a very simplistic EC2 Instance to act as a GitHub Self Hosted Runner. It is left to any future reader/user/forker of this Repository to tailor it accordingly to their own needs.

## Authors

Colin But
