terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "cloudops-terraform-state-nidhi"
    key = "dev/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "../../modules/vpc"
  vpc_cidr = var.vpc_cidr
  public_subnet_cidr_az1 = var.public_subnet_cidr_az1
  public_subnet_cidr_az2 = var.public_subnet_cidr_az2
  private_subnet_cidr_az1 = var.private_subnet_cidr_az1
  private_subnet_cidr_az2 = var.private_subnet_cidr_az2
  az1 = var.az1
  az2 = var.az2
  environment = var.environment
}


module "security_group" {
  source = "../../modules/security_group"
  vpc_id = module.vpc.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr  
  environment = var.environment
}

module "bastion" {
  source = "../../modules/bastion"
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  public_subnet_az1_id = module.vpc.public_subnet_az1_id
  public_subnet_az2_id = module.vpc.public_subnet_az2_id
  bastion_sg_id        = module.security_group.bastion_sg_id
  environment          = var.environment
}

module "alb" {
  source = "../../modules/alb"
  vpc_id = module.vpc.vpc_id
  public_subnet_az1_id = module.vpc.public_subnet_az1_id
  public_subnet_az2_id = module.vpc.public_subnet_az2_id
  alb_sg_id = module.security_group.alb_sg_id
  environment = var.environment
}

module "asg" {
  source = "../../modules/asg"
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  key_name              = var.key_name
  ec2_sg_id             = module.security_group.ec2_sg_id
  private_subnet_az1_id = module.vpc.private_subnet_az1_id
  private_subnet_az2_id = module.vpc.private_subnet_az2_id
  target_group_arn      = module.alb.target_group_arn
  environment           = var.environment
}
