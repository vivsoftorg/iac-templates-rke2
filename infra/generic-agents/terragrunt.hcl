locals {
  common       = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))

}

terraform {
  source = "../../../../../modules/agent-nodepool/"
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

    arguments = [
      "-var-file=../../../../../tfvars.json"
    ]
  }
}

include {
  path = find_in_parent_folders()
}

dependency "main" {
  config_path = "../main"
  mock_outputs = {
    cluster_data = {
      name       = "dummy"
      cluster_sg = "dummy"
      server_url = "dummy"
      token      = { bucket = "dummy", bucket_arn = "dummy", object = "", policy_document = "{}" }
    }
  }
}

dependency "vpc" {
    config_path = "../../../../../env/dev/us-east-1/vpc"
    mock_outputs = {
        private_subnets = ["dummy_subnet"]
        public_subnets = ["dummy_subnet"]
        vpc_id = "dummy_vpc"
    }
}

inputs = {
  name                      = get_env("CLUSTER_NAME", "vivsoft-p1-k8s")
  vpc_id                    = dependency.vpc.outputs.vpc_id
  subnets                   = dependency.vpc.outputs.public_subnets
  asg                       = { min : 2, max : 10, desired : 3 }
  enable_ccm                = true
  enable_autoscaling        = true
  instance_type             = "c4.4xlarge"
  iam_instance_profile      = "InstanceOpsProfile"
  spot                      = true
  private_registry_password = get_env("REGISTRY_PASSWORD", "")
  private_registry_username = get_env("REGISTRY_USERNAME", "")
  # Required output from rke2 server
  cluster_data = dependency.main.outputs.cluster_data

  # TODO: These need to be set in pre-baked ami's
  pre_userdata = <<-EOF
# Temporarily disable selinux enforcing due to missing policies in containerd
# The change is currently being upstreamed and can be tracked here: https://github.com/rancher/k3s/issues/2240
setenforce 0

# Tune vm sysct for elasticsearch
sysctl -w vm.max_map_count=262144
EOF

  tags = {
    impact_level = "${local.common.locals.impact_level}"
    account      = "${local.account_vars.locals.account_name}"
  }
}
