# ------------------------------------
# PUBLIC INSTANCE SECURITY GROUP
# ------------------------------------
resource "aws_security_group" "public_sg" {
  name        = "public-instance-sg"
  description = "Public Instance SG"
  vpc_id      = var.vpc_id

  # SSH only from 172.31.0.0/16
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP public
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS public
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 8080 public
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public-Instance-SG"
  }
}

# ------------------------------------
# PRIVATE INSTANCE SECURITY GROUP
# ------------------------------------
resource "aws_security_group" "private_sg" {
  name        = "private-instance-sg"
  description = "Private Instance SG"
  vpc_id      = var.vpc_id

  # SSH private
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  }

  # MySQL private
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private-Instance-SG"
  }
}
