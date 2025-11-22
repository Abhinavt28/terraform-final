variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet1_cidr" {
  default = "10.0.2.0/24"
}

variable "private_subnet2_cidr" {
  default = "10.0.3.0/24"
}

variable "az1" {
  default = "us-east-1a"
}

variable "az2" {
  default = "us-east-1b"
}

variable "default_vpc_id" {
  default = "vpc-02f2f90f4e16033f8"
}

variable "ami_id" {
  default = "ami-0c398cb65a93047f2"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "ubuntu"
}
