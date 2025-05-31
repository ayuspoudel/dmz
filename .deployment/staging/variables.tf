variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "dmz-staging"
}

variable "environment" {
  type    = string
  default = "staging"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "availability_zone" {
  type    = string
  default = "us-east-1a"
}

variable "key_name" {
  type    = string
  default = "dmz-key"
}

variable "public_key_path" {
  type    = string
  default = ".ssh/dmz-key.pub"
}

variable "ami" {
  type    = string
  default = "ami-084568db4383264d4" # Ubuntu 22.04
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}
