module "variables" {
  source = "../../variables"
}

terraform {
  backend "s3" {
    bucket   = "tfstate-bucket-mdalbes"
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
  name                        = module.variables.prisma_aws_account_name_1
  aws_account_id              = module.variables.aws_account_id_1
  # existing_account_group_name = module.variables.existing_account_group_name_1
  new_account_group_name      = module.variables.new_account_group_name_1
}