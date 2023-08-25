module "variables" {
  source = "../../variables"
}


provider aws {
  region  = module.variables.region
  profile = module.variables.username
}

terraform {
  backend "s3" {
    bucket   = "tfstate-bucket-umbrella"
    key      = "tfstate/terraform.tfstate-eks"
    region   = "us-east-1"

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

resource "random_integer" "unique_id" {
  min = 1000
  max = 9999
}

#############################################################
##################     EKS Cluster    #######################
#############################################################


resource "aws_eks_cluster" "Umbrella-EKS-Cluster" {
  kubernetes_network_config {
    ip_family         = "ipv4"
    service_ipv4_cidr = "10.100.0.0/16"
  }

  name     = "Umbrella-EKS-Cluster-${random_integer.unique_id.id}"
  role_arn = aws_iam_role.Umbrella-AmazonEKSClusterRole.arn
  version  = "1.23"

  vpc_config {
    endpoint_private_access = "false"
    endpoint_public_access  = "true"
    public_access_cidrs     = ["0.0.0.0/0"]
    subnet_ids              = [data.aws_subnet.my_public_subnet_1.id, data.aws_subnet.my_public_subnet_2.id]
  }
}

resource "aws_iam_policy" "Umbrella-eksWorkNodeEBSPolicy" {
  name = "Umbrella-eksWorkNodeEBSPolicy-${random_integer.unique_id.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteSnapshot",
        "ec2:DeleteTags",
        "ec2:DeleteVolume",
        "ec2:DescribeInstances",
        "ec2:DescribeSnapshots",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DetachVolume"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "Umbrella-MongoDBPolicy" {
  name = "Umbrella-MongoDBPolicy-${random_integer.unique_id.id}"
  path = "/"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "ec2:*",
      "Effect": "Allow",
      "Resource": "*",
      "Sid": "VisualEditor0"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_iam_role" "Umbrella-AmazonEKSNodeRole" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  description          = "Allows EC2 instances to call AWS services on your behalf."
  managed_policy_arns  = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly", "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy","${aws_iam_policy.Umbrella-eksWorkNodeEBSPolicy.arn}"]
  max_session_duration = "3600"
  name                 = "Umbrella-AmazonEKSNodeRole-${random_integer.unique_id.id}"
  path                 = "/"
}

resource "aws_iam_role" "Umbrella-AmazonEKSClusterRole" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  description          = "Allows access to other AWS service resources that are required to operate clusters managed by EKS."
  managed_policy_arns  = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]
  max_session_duration = "3600"
  name                 = "Umbrella-AmazonEKSClusterRole-${random_integer.unique_id.id}"
  path                 = "/"
}

resource "aws_iam_role" "Umbrella-MongoDBRole" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  description          = "Allows EC2 instances to call AWS services on your behalf."
  managed_policy_arns  = [aws_iam_policy.Umbrella-MongoDBPolicy.arn,"arn:aws:iam::aws:policy/AmazonS3FullAccess"]
  max_session_duration = "3600"
  name                 = "Umbrella-MongoDBRole-${random_integer.unique_id.id}"
  path                 = "/"
}


resource "aws_eks_node_group" "Umbrella-EKS-NodeGrp" {
  ami_type        = "AL2_x86_64"
  capacity_type   = "ON_DEMAND"
  cluster_name    = "${aws_eks_cluster.Umbrella-EKS-Cluster.name}"
  disk_size       = "20"
  instance_types  = ["t3.medium"]
  node_group_name = "Umbrella-EKS-NodeGrp-${random_integer.unique_id.id}"
  node_role_arn   = aws_iam_role.Umbrella-AmazonEKSNodeRole.arn
  release_version = "1.23.7-20220802"

  scaling_config {
    desired_size = "2"
    max_size     = "2"
    min_size     = "1"
  }

  subnet_ids              = [data.aws_subnet.my_public_subnet_1.id, data.aws_subnet.my_public_subnet_2.id]

  update_config {
    max_unavailable = "1"
  }

  version = "1.23"
}
