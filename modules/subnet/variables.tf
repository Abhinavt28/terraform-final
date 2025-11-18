variable "vpc_id" {}

variable "public_subnet_cidr" {}
variable "private_subnet1_cidr" {}
variable "private_subnet2_cidr" {}

variable "az1" {}
variable "az2" {}

variable "igw_id" {
  description = "Internet Gateway ID for Public Route Table"
}

variable "nat_gw_id" {
  description = "NAT Gateway ID for Private Route Table"
}
