module "variables" {
  source = "../../variables"
}

terraform {
  backend "s3" {
    bucket   = "tfstate-bucket-umbrella-5289"
    key      = "tfstate/terraform.tfstate-prisma-onboard-account"
    region   = "us-east-1"

  }
}

terraform {
  required_providers {
    prismacloud = {
      source = "PaloAltoNetworks/prismacloud"
      version = ">=1.1.0"
    }
  }
}

provider "prismacloud" {
    json_config_file = "prismacloud_auth.json"
}



module "account_1" {
  source = "../../module/prisma_onboard_account"
  name                        = "terraform-account-prisma-umbrella-5289"
  aws_account_id              = module.variables.aws_account_id_1
  # existing_account_group_name = module.variables.existing_account_group_name_1
  new_account_group_name      = "acg-umbrella-5289"
}
