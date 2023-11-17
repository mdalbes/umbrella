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
  tfstate_bucket_name        = "tfstate-bucket-umbrella-1626"
  dynamodb_name              =  "tfstate-dynamodb-umbrella-1626"
  region                     = module.variables.region
}
