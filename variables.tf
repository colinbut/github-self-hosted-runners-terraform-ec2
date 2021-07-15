variable "ami" {
  description = "The AMI for the GitHub Runner backing EC2 Instance"
  type        = string
}

variable "instance_type" {
  description = "The type of the EC2 instance backing the GitHub Runner"
  type        = string
}

variable "key_name" {
  description = "The KeyPair name for accessing (SSH) into the EC2 instance backing the GitHub Runner"
  type        = string
}