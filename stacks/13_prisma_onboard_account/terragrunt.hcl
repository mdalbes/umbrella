dependencies {
  paths = ["../04_kubernetes", "../03_eks_cluster", "../02_ec2", "../01_vpc"]
}

include "root" {
  path = find_in_parent_folders()
}