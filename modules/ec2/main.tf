# ======================================================
# PUBLIC EC2 INSTANCE
# ======================================================
resource "aws_instance" "public" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet
  key_name               = var.key_name
  vpc_security_group_ids = [var.public_sg_id]

  associate_public_ip_address = true

  tags = {
    Role = "client"
    Name = "Client-server"
  }
}

# ======================================================
# PRIVATE EC2 INSTANCE 1
# ======================================================
resource "aws_instance" "private1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet1
  key_name               = var.key_name
  vpc_security_group_ids = [var.private_sg_id]

  tags = {
    Role = "server"
    Name = "Slave-DB"
  }
}

# ======================================================
# PRIVATE EC2 INSTANCE 2
# ======================================================
resource "aws_instance" "private2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet2
  key_name               = var.key_name
  vpc_security_group_ids = [var.private_sg_id]

  tags = {
    Role = "server"
    Name = "Master-DB"
  }
}
