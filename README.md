# Github Self-Hosted Runners (Terraform) (EC2)

This is a Terraform repository that contains Terraform code to spin up an EC2 Instance acting as the GitHub Self Hosted Runner for a particular GitHub Repository.

## Usage

In order to use this Repository to construct your GitHub Self Hosted Runners for a given GitHub Repository; you will first require to generate a GitHub "PAT" token for which this token will be used by the GitHub Self Hosted Runners (EC2 Instances) to authenticate on your behalf to the GitHub Repository you wanted the GitHub Self Hosted Runners to run your GitHub Actions Workflows.

This can be easily done by following this guide:
https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token

If you are the owner of the GitHub Repository for which you want to setup GitHub Self Hosted Runners for then no further action on the GitHub side is required.
Otherwise, if you're not the owner of the GitHub Repository you need to be added to the GitHub Repository as an "outside collaborator" with the appropriate priviledges. Instructions can be found here: https://docs.github.com/en/organizations/managing-access-to-your-organizations-repositories/adding-outside-collaborators-to-repositories-in-your-organization

In full, the owner of the PAT token will need to have the appropriate rights to the GitHub Repository you are trying to setup GitHub Self Hosted Runners for using this Repository.

Once you configured the PAT token and connected your GitHub Repository to the PAT token owner (as described above); you can then proceed as follows to continue with setting up this GitHub Self Hosted Runners Repository by executing the standard Terraform workflow to provision the GitHub Self Hosted Runners infrastructure resources on AWS Cloud.

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

health_check_grace_period = 600
desired_capacity          = 3
min_size                  = 1
max_size                  = 4
```

where owner and repo represents the GitHub Account Owner & Repository respectively.

In above example i have the desired capacity of 3 for the number of instances in the Auto Scaling Group to denote how many desired runner instances i want for my GitHub Repository where i also set the minimum and maximum too.



## Information

### VPC
Note that by design not launching the EC2 Auto Scaling Group in a VPC simply because i want this GitHub Runners project to contain an independent GitHub Runner that can be launched directly into any VPC if needed. Since after all the aim of this Repository Project is to demonstrate the construction of GitHub Self Hosted Runners on EC2 instances.

As a result, this project enables the spinning up of a very simplistic EC2 Instance to act as a GitHub Self Hosted Runner. It is left to any future reader/user/forker of this Repository to tailor it accordingly to their own needs.

## Authors

Colin But
