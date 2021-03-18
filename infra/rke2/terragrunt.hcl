locals {
  common       = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/rke-k8s/"
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

    arguments = [
      "-var-file=../../../../../tfvars.json"
    ]
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
  cluster_name         = get_env("CLUSTER_NAME", "vivsoft-p1-k8s")
  vpc_id               = dependency.vpc.outputs.vpc_id
  subnets              = dependency.vpc.outputs.public_subnets
  instance_type        = "t3a.large"
  iam_instance_profile = "InstanceOpsProfile"
  enable_ccm           = true


  asg = { min : 1, max : 7, desired : 1 }
  # TODO: These need to be set in pre-baked ami's
  pre_userdata = <<-EOF
  # Temporarily disable selinux enforcing due to missing policies in containerd
  # The change is currently being upstreamed and can be tracked here: https://github.com/rancher/k3s/issues/2240
  setenforce 0

  # Tune vm sysctl for elasticsearch
  sysctl -w vm.max_map_count=262144
  EOF

  tags = {
    impact_level = "${local.common.locals.impact_level}"
    account      = "${local.account_vars.locals.account_name}"
    Owner        = "PartyBus"
  }
}
