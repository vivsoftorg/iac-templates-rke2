# Provision rke2 server(s) and controlplane loadbalancer
module "rke2" {
  source                                        = "git::https://github.com/rancherfederal/rke2-aws-tf.git?ref=v1.1.9"
  cluster_name                                  = var.cluster_name
  unique_suffix                                 = var.unique_suffix
  vpc_id                                        = var.vpc_id
  subnets                                       = var.subnets
  tags                                          = var.tags
  instance_type                                 = var.instance_type
  ami                                           = data.aws_ami.rhel8.id
  iam_instance_profile                          = var.iam_instance_profile
  iam_permissions_boundary                      = var.iam_permissions_boundary
  block_device_mappings                         = var.block_device_mappings
  extra_block_device_mappings                   = var.extra_block_device_mappings
  servers                                       = var.servers
  spot                                          = var.spot
  ssh_authorized_keys                           = var.ssh_authorized_keys
  extra_security_group_ids                      = var.extra_security_group_ids
  controlplane_enable_cross_zone_load_balancing = var.controlplane_enable_cross_zone_load_balancing
  controlplane_internal                         = var.controlplane_internal
  controlplane_allowed_cidrs                    = var.controlplane_allowed_cidrs
  rke2_version                                  = var.rke2_version
  rke2_config                                   = var.rke2_config
  download                                      = var.download
  pre_userdata                                  = var.pre_userdata
  post_userdata                                 = var.post_userdata
  enable_ccm                                    = var.enable_ccm
}

# Provision Auto Scaling Group of agents to auto-join cluster
module "rke2_agents" {
  source                      = "git::https://github.com/rancherfederal/rke2-aws-tf.git//modules/agent-nodepool?ref=v1.1.9"
  name                        = var.nodepool_name
  vpc_id                      = var.nodepool_vpc_id
  subnets                     = var.nodepool_subnets
  instance_type               = var.nodepool_instance_type
  ami                         = data.aws_ami.rhel8.id
  tags                        = var.nodepool_tags
  iam_instance_profile        = var.nodepool_iam_instance_profile
  iam_permissions_boundary    = var.nodepool_iam_permissions_boundary
  ssh_authorized_keys         = var.nodepool_ssh_authorized_keys
  block_device_mappings       = var.nodepool_block_device_mappings
  extra_block_device_mappings = var.nodepool_extra_block_device_mappings
  asg                         = var.nodepool_asg
  spot                        = var.nodepool_spot
  extra_security_group_ids    = var.nodepool_extra_security_group_ids
  cluster_data                = module.rke2.cluster_data # Required input sourced from parent rke2 module, contains configuration that agents use to join existing cluster
  rke2_version                = var.nodepool_rke2_version
  rke2_config                 = var.nodepool_rke2_config
  enable_ccm                  = var.nodepool_enable_ccm
  enable_autoscaler           = var.nodepool_enable_autoscaler
  download                    = var.nodepool_download
  pre_userdata                = var.nodepool_pre_userdata
  post_userdata               = var.nodepool_post_userdata
}
