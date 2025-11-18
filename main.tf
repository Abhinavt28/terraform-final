provider "aws" {
  region = "us-east-1"
}

# -----------------------
# VPC Module
# -----------------------
module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
}

# -----------------------
# Subnet Module
# -----------------------
module "subnet" {
  source               = "./modules/subnet"
  vpc_id               = module.vpc.vpc_id
  public_subnet_cidr   = var.public_subnet_cidr
  private_subnet1_cidr = var.private_subnet1_cidr
  private_subnet2_cidr = var.private_subnet2_cidr
  az1                  = var.az1
  az2                  = var.az2

  igw_id    = module.vpc.igw_id # IGW id pass here
  nat_gw_id = module.nat.nat_id # NAT id pass here
}

# -----------------------
# NAT Gateway Module
# -----------------------
module "nat" {
  source        = "./modules/nat"
  vpc_id        = module.vpc.vpc_id
  public_subnet = module.subnet.public_subnet_id
  private_rt_id = module.subnet.private_rt_id
}

# -----------------------
# Security Group Module
# -----------------------
module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

# -----------------------
# EC2 Module
# -----------------------
module "ec2" {
  source        = "./modules/ec2"
  ami_id        = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  public_subnet   = module.subnet.public_subnet_id
  private_subnet1 = module.subnet.private_subnet1_id
  private_subnet2 = module.subnet.private_subnet2_id

  public_sg_id  = module.sg.public_sg_id
  private_sg_id = module.sg.private_sg_id
}

# -----------------------
# Peering Module
# -----------------------
module "peering" {
  source          = "./modules/peering"
  custom_vpc_id   = module.vpc.vpc_id
  custom_vpc_cidr = var.vpc_cidr
  default_vpc_id  = var.default_vpc_id
  public_rt_id    = module.subnet.public_rt_id
  private_rt_id   = module.subnet.private_rt_id
}
