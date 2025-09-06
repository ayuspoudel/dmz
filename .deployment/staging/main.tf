provider "aws" {
  region = var.aws_region
}

terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

# Define common tags
locals {
  tags = {
    Project = var.project_name
    Env     = var.environment
  }
}

# Generate an RSA SSH key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create an EC2 key pair using the generated public key
resource "aws_key_pair" "this" {
  key_name   = "dmz-ssh-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Store the public key in AWS Secrets Manager
resource "aws_secretsmanager_secret" "public_key" {
  name        = "dmz-ssh-key-public"
  description = "Public key for SSH access"
  tags        = local.tags
}

resource "aws_secretsmanager_secret_version" "public_key_version" {
  secret_id     = aws_secretsmanager_secret.public_key.id
  secret_string = tls_private_key.ssh_key.public_key_openssh
}

# Store the private key in AWS Secrets Manager (for CI/CD use only)
resource "aws_secretsmanager_secret" "private_key" {
  name        = "dmz-ssh-key-private"
  description = "Private key for SSH access (CI/CD only)"
  tags        = local.tags
}

resource "aws_secretsmanager_secret_version" "private_key_version" {
  secret_id     = aws_secretsmanager_secret.private_key.id
  secret_string = tls_private_key.ssh_key.private_key_pem
}

# Create a VPC
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags       = merge(local.tags, { Name = "${var.project_name}-vpc" })
}

# Create a public subnet in the VPC
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = merge(local.tags, { Name = "${var.project_name}-public-subnet" })
}

# Create a security group that allows SSH access
resource "aws_security_group" "ssh" {
  name        = "${var.project_name}-sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, { Name = "${var.project_name}-sg" })
}

# Launch an EC2 instance with SSH access
resource "aws_instance" "dmz" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true

  tags = merge(local.tags, { Name = "${var.project_name}-instance" })
}

# Create an internet gateway for public access
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.tags, { Name = "${var.project_name}-igw" })
}

# Create a route table for internet access
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(local.tags, { Name = "${var.project_name}-public-rt" })
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Get the ARN of the private key secret
data "aws_secretsmanager_secret" "private_key" {
  name = "dmz-ssh-key-private"
}

# Create IAM Role for CI/CD
resource "aws_iam_role" "cicd" {
  name = "dmz-cicd-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com" # or change to GitHub Actions oidc/CI service
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = local.tags
}

# IAM Policy for limited EC2 + Secret access
resource "aws_iam_role_policy" "cicd_limited_access" {
  name = "dmz-cicd-access"
  role = aws_iam_role.cicd.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = data.aws_secretsmanager_secret.private_key.arn
      },
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeInstances",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:RebootInstances",
          "ec2:CreateTags",
          "ec2:TerminateInstances"
        ],
        Resource = aws_instance.dmz.arn
      }
    ]
  })
}

resource "aws_iam_access_key" "cicd" {
  user = aws_iam_user.cicd_user.name
}

resource "aws_iam_user" "cicd_user" {
  name = "dmz-cicd-user"
  tags = local.tags
}

resource "aws_iam_user_policy_attachment" "cicd_attach" {
  user       = aws_iam_user.cicd_user.name
  policy_arn = "arn:aws:iam::aws:policy/YourCustomPolicy"
}
