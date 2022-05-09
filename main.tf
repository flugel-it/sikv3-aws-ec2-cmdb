##############
# Data sources
##############

# Get instance image ID
data "aws_ami" "ami" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["cmdbuild"]
  }
}

# Get the default VPC id to deploy the security group
data "aws_vpc" "main" {
  default = true
}

resource "aws_instance" "cmdbuild" {
  ami           = data.aws_ami.ami.id
  instance_type = var.instance_type

  # the VPC subnet
  subnet_id = var.subnet_id

  # the security group
  vpc_security_group_ids      = [aws_security_group.allow-http.id]
  associate_public_ip_address = var.associate_public_ip_address

  # the public SSH key
  key_name = var.key_name

  depends_on = [resource.local_file.private_key]

}

resource "aws_security_group" "allow-http" {
  vpc_id      = data.aws_vpc.main.id
  name        = "allow-http"
  description = "security group that allows http, shh and all egress traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-http"
  }
}

################
# Key Pair
################
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "private_key" {
  key_name   = var.key_name
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "local_file" "private_key" {
  sensitive_content = tls_private_key.private_key.private_key_pem
  filename          = "artifacts/private.pem"
}