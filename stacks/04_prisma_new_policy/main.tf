module "variables" {
  source = "../../variables"
}

terraform {
  backend "s3" {
    bucket   = "tfstate-bucket-mdalbes"
    key      = "tfstate/terraform.tfstate-prisma-new-policy"
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



module "policy_1" {
  source            = "../../module/prisma_policy"
  search_type       = module.variables.search_type_1
  query             = "config from cloud.resource where cloud.account = '${module.variables.prisma_aws_account_name_1}' and api.name = 'aws-ec2-describe-security-groups' AND json.rule = ipPermissions[*].toPort is not member of (443,80)"
  unit              = module.variables.unit_1
  amount            = module.variables.amount_1
  savedsearch_name  = module.variables.savedsearch_name_1
  policy_name       = module.variables.policy_name_1
  rule_name         = module.variables.rule_name_1
  policy_type       = module.variables.policy_type_1
  rule_type         = module.variables.rule_type_1
}