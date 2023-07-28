#############################################################
####################  provider  #############################
#############################################################

variable "region" {
  type = string
  default = "us-east-1"
}
output "region" {
  value = var.region
}

variable "username" {
  type = string
  default = "acloudguru"
}
output "username" {
  value = var.username
}

#############################################################
################     Remote_state      ######################
#############################################################


variable "tfstate_bucket_name" {
  type    = string
  default = "tfstate-bucket-mdalbes"
}

output "tfstate_bucket_name" {
  value = var.tfstate_bucket_name
}


variable "dynamodb_name" {
  type    = string
  default = "tfstate-dynamodb-mdalbes"
}

output "dynamodb_name" {
  value = var.dynamodb_name
}

#############################################################
####################   Instances   ##########################
#############################################################

variable "key_name" {
  description = "Name of the Instance keyname"
  type        = string
  default     = "mdalbes-instance"
}

output "key_name" {
  value = var.key_name
}



variable "filename" {
  description = "pem Path"
  type        = string
  default     = "C:\\Users\\mdalbes\\Desktop\\repo\\Terraform_module\\mdalbes-instance.pem"
}

output "filename" {
  value = var.filename
}

variable "myIP" {
  description = "myIP"
  type        = string
  default     = "52.47.138.194/32"
}

output "myIP" {
  value = var.myIP
}


#############################################################
######################   VPC   ##############################
#############################################################

variable "vpc_cidrs" {
  type = string
  default = "10.0.0.0/16"   
  }


output "vpc_cidrs" {
  value = var.vpc_cidrs
}
variable "vpc_name" {
  type = string
  default = "Terraform_module_VPC"   
  }


output "vpc_name" {
  value = var.vpc_name
}
 
variable "az_list" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}


output "az_list" {
  value = var.az_list
}

variable "short_az_list" {
  type    = list(string)
  default = ["a","b"]
}

output "short_az_list" {
  value = var.short_az_list
}

variable "log_group_name" {
  type    = string
  default = "vpc01_loggroups"
}

output "log_group_name" {
  value = var.log_group_name
}





#############################################################
####################   SUBNETS   ############################
#############################################################

variable "private_subnet_cidrs" {
  type = map
  default = {
    compute = ["10.0.2.0/24", "10.0.3.0/24"]  
    database  = ["10.0.4.0/24", "10.0.5.0/24"]
  }
}

output "private_subnet_cidrs" {
  value = var.private_subnet_cidrs
}

variable "public_subnets" {
  type = list(string)
  default = ["10.0.0.0/24","10.0.1.0/24"]
}

output "public_subnets" {
  value = var.public_subnets
}

variable "public_subnet_suffix" {
  description = "Suffix to append to public subnets name"
  type        = string
  default     = "public"
}

output "public_subnet_suffix" {
  value = var.public_subnet_suffix
}

variable "public_subnet_name" {
  description = "Name to append to public subnets name"
  type        = string
  default     = ""
}

output "public_subnet_name" {
  value = var.public_subnet_name
}



#############################################################
####################   Prisma    ############################
#############################################################


#######   Account ID 1     ########


variable "aws_account_id_1" {
  type = string
  default = "293440400647"
}
output "aws_account_id_1" {
  value = var.aws_account_id_1
}

variable "prisma_aws_account_name_1" {
  type = string
  default = "mdalbes-terraform-account-prisma-10"
}
output "prisma_aws_account_name_1" {
  value = var.prisma_aws_account_name_1
}

variable "existing_account_group_name_1" {
  type = string
  default = "mdalbes-acg-lab-10"
}


output "existing_account_group_name_1" {
  value = var.existing_account_group_name_1
}

variable "new_account_group_name_1" {
  type = string
  default = "mdalbes-acg-lab-10"
}

output "new_account_group_name_1" {
  value = var.new_account_group_name_1
}


#######   Policy 1     ########


variable "policy_name_1" {
  type = string
  default = "policy_non_web_port_open_mdalbes-10"
}
output "policy_name_1" {
  value = var.policy_name_1
}

variable "rule_name_1" {
  type = string
  default = "rule_non_web_port_open_mdalbes-10"
}
output "rule_name_1" {
  value = var.rule_name_1
}


variable "search_type_1" {
  type = string
  default = "config"
}
output "search_type_1" {
  value = var.search_type_1
}

variable "savedsearch_name_1" {
  type = string
  default = "saved query non web 10"
}
output "savedsearch_name_1" {
  value = var.savedsearch_name_1

}

variable "unit_1" {
  type = string
  default = "day"
}
output "unit_1" {
  value = var.unit_1

}

variable "amount_1" {
  type = string
  default = "7"
}
output "amount_1" {
  value = var.amount_1

}

variable "policy_type_1" {
  type = string
  default = "config"
}
output "policy_type_1" {
  value = var.policy_type_1

}

variable "rule_type_1" {
  type = string
  default = "Config"
}
output "rule_type_1" {
  value = var.rule_type_1

}


#######   Alert 1     ########

variable "alert_rule_name_1" {
  type = string
  default =  "mdalbes-non-web-port-open-alert"
}
output "alert_rule_name_1" {
  value = var.alert_rule_name_1

}


variable "notification_config_type" {
  type = string
  default =  "email"
}
output "notification_config_type" {
  value = var.notification_config_type

}

variable "notification_recipients" {
  type = list(string)
  default =  ["mdalbes@paloaltonetworks.com"]
}
output "notification_recipients" {
  value = var.notification_recipients

}


