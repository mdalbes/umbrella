module "variables" {
  source = "../../variables"
}
provider aws {
  region  = module.variables.region
  profile = module.variables.username
}


#Remote State
module "remote_state" {
  source                     = "../../module/remote-tfstate"
  tfstate_bucket_name        = module.variables.tfstate_bucket_name
  dynamodb_name              = module.variables.dynamodb_name
  region                     = module.variables.region
}