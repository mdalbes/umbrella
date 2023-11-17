
module "variables" {
  source = "../../variables"
}

terraform {
  backend "s3" {
    bucket   = "tfstate-bucket-umbrella-1626"
    key      = "tfstate/terraform.tfstate-prisma-alert-rule"
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
  source            = "../../module/prisma_alert"
  policy_name                    = "policy-umbrella-1626"
  existing_account_group_name    = module.variables.existing_account_group_name_1
  alert_rule_name                = "alert-rule-non-web-port-open-alert-umbrella-1626" 
  notification_config_type       = module.variables.notification_config_type
  notification_recipients        = module.variables.notification_recipients
}


