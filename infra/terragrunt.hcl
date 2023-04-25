locals {
  aws_region         = get_env("AWS_DEFAULT_REGION", "us-east-1")
  stack              = get_env("STACK_NAME", format("%.11s", basename(dirname(replace(get_parent_terragrunt_dir(), "infra", "")))))
  stack_name         = lower(replace(local.stack, "_", "-"))
  environment        = replace(path_relative_to_include(), "environments/", "")
  env_vars           = read_terragrunt_config(find_in_parent_folders("env.json", "env.json"), { inputs = {} })
  vpc_vars           = read_terragrunt_config(find_in_parent_folders("vpc.json", "vpc.json"), { inputs = {} })
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket  = "${local.stack_name}-${local.aws_region}-${get_aws_account_id()}-tfstate"
    key     = "infra/${local.environment}/terraform.tfstate"
    region  = local.aws_region
    encrypt = true
  }
}



terraform {
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()
  }
}

inputs = merge(
  local.vpc_vars.inputs,
  local.env_vars.inputs,
  {
    environment                     = local.environment
    aws_region                      = local.aws_region
    stack_name                      = local.stack_name
  }
)