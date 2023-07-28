module "variables" {
  source = "../../variables"
}


provider aws {
  region  = module.variables.region
  profile = module.variables.username
}

terraform {
  backend "s3" {
    bucket   = "tfstate-bucket-mdalbes"
    key      = "tfstate/terraform.tfstate-ec2"
    region   = "us-east-1"

  }
}

#############################################################
##################     DataSource     #######################
#############################################################

data "aws_vpc" "myVPC" {
  filter {
    name = "tag:Name"
    values = [module.variables.vpc_name]
  }
}

data "aws_subnet" "my_public_subnet_1" {
  filter {
    name = "tag:Name"
    values = ["public-a"]
  }
}


data "aws_subnet" "my_public_subnet_2" {
  filter {
    name = "tag:Name"
    values = ["public-b"]
  }
}

#############################################################
##################     Instance     #########################
#############################################################

# Create the Key Pair

resource "tls_private_key" "instance" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "instance" {
  key_name   = module.variables.key_name  
  public_key = "${tls_private_key.instance.public_key_openssh}"
}
# Save file
resource "local_file" "ssh_key" {
  filename = module.variables.filename
  content  = tls_private_key.instance.private_key_pem
}

locals {
  ports_in = [
    443,
    22
  ]
  ports_out = [
    0
  ]
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls_ssh"
  description = "Allow TLS & SSH inbound traffic"
  vpc_id      = data.aws_vpc.myVPC.id
  
   ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.variables.myIP,module.variables.public_subnets[0],module.variables.public_subnets[1]]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [module.variables.myIP,module.variables.public_subnets[0],module.variables.public_subnets[1]]
  }

   ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [module.variables.myIP,module.variables.public_subnets[0],module.variables.public_subnets[1]]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  }

#Instance 1 
module "instance_1" {
  source = "../../module/ec2_instance"
  name                        = "Instance1"
  ami_filter                  = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.my_public_subnet_1.id
  key_name                    = aws_key_pair.instance.key_name
  vpc_security_group_ids      = [aws_security_group.allow_tls.id]
  associate_public_ip_address = true
}


module "instance_2" {
  source = "../../module/ec2_instance"
  name                        = "Instance2"
  ami_filter                  = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.my_public_subnet_2.id
  key_name                    = aws_key_pair.instance.key_name
  vpc_security_group_ids      = [aws_security_group.allow_tls.id]
  associate_public_ip_address = true
}

