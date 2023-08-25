data "terraform_remote_state" "eks" {
  backend = "local"

  config = {
    path = "../03_eks_cluster/.terraform/terraform.tfstate"
  }
}


data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../01_vpc/.terraform/terraform.tfstate"
  }
}
