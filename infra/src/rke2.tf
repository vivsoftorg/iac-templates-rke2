data "aws_ami" "rhel8" {
  most_recent = true
  owners      = ["309956199498", "219670896067"] # "219670896067" Govloud RHEL8 , 309956199498 AWS RHEL8 Commercial

  filter {
    name   = "name"
    values = ["RHEL-8*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "null_resource" "create_target_dir" {
  provisioner "local-exec" {
    command = "mkdir -p target"
  }
}

# Private Key
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "pem" {
  filename        = "target/${var.cluster_name}.pem"
  content         = tls_private_key.ssh.private_key_pem
  file_permission = "0600"
}

# Provision rke2 server(s) and controlplane loadbalancer
module "rke2" {
  source = "./modules/rke2-aws-tf/"
  // source                                        = "git::https://github.com/rancherfederal/rke2-aws-tf.git?ref=v2.5.0"
  cluster_name                                     = local.name
  unique_suffix                                    = var.unique_suffix
  vpc_id                                           = var.create_vpc ? module.vpc[0].vpc_id : var.vpc_id
  lb_subnets                                       = var.create_vpc ? module.vpc[0].public_subnets : var.lb_subnets
  subnets                                          = var.create_vpc ? module.vpc[0].public_subnets : var.subnets
  tags                                             = var.tags
  instance_type                                    = var.instance_type
  ami                                              = data.aws_ami.rhel8.image_id
  iam_instance_profile                             = var.iam_instance_profile
  iam_permissions_boundary                         = var.iam_permissions_boundary
  block_device_mappings                            = var.block_device_mappings
  extra_block_device_mappings                      = var.extra_block_device_mappings
  extra_security_group_ids                         = var.extra_security_group_ids
  servers                                          = var.servers
  spot                                             = var.spot
  ssh_authorized_keys                              = [tls_private_key.ssh.public_key_openssh]
  suspended_processes                              = var.suspended_processes
  termination_policies                             = var.termination_policies
  controlplane_enable_cross_zone_load_balancing    = var.controlplane_enable_cross_zone_load_balancing
  controlplane_internal                            = var.controlplane_internal
  controlplane_allowed_cidrs                       = var.controlplane_allowed_cidrs
  controlplane_access_logs_bucket                  = var.controlplane_access_logs_bucket
  metadata_options                                 = var.metadata_options
  rke2_channel                                     = var.rke2_channel
  rke2_version                                     = var.rke2_version
  rke2_config                                      = var.rke2_config
  download                                         = var.download
  pre_userdata                                     = var.pre_userdata
  post_userdata                                    = var.post_userdata
  enable_autoscaler                                = var.enable_autoscaler
  enable_ccm                                       = var.enable_ccm
  ccm_external                                     = var.ccm_external
  wait_for_capacity_timeout                        = var.wait_for_capacity_timeout
  associate_public_ip_address                      = var.associate_public_ip_address
  extra_cloud_config_config                        = var.extra_cloud_config_config
  rke2_install_script_url                          = var.rke2_install_script_url
  awscli_url                                       = var.awscli_url
  unzip_rpm_url                                    = var.unzip_rpm_url
  rke2_start                                       = var.rke2_start
  statestore_attach_deny_insecure_transport_policy = var.statestore_attach_deny_insecure_transport_policy
  create_acl                                       = var.create_acl
}

# Provision Auto Scaling Group of agents to auto-join cluster
module "rke2_agents" {
  source = "./modules/rke2-aws-tf/modules/agent-nodepool/"
  // source                      = "git::https://github.com/rancherfederal/rke2-aws-tf.git//modules/agent-nodepool?ref=v2.5.0"
  name                        = "generic"
  vpc_id                      = var.create_vpc ? module.vpc[0].vpc_id : var.vpc_id
  subnets                     = var.create_vpc ? module.vpc[0].private_subnets : var.subnets
  instance_type               = var.instance_type
  ami                         = data.aws_ami.rhel8.image_id
  tags                        = var.tags
  iam_instance_profile        = var.iam_instance_profile
  iam_permissions_boundary    = var.iam_permissions_boundary
  ssh_authorized_keys         = [tls_private_key.ssh.public_key_openssh]
  block_device_mappings       = var.block_device_mappings
  extra_cloud_config_config   = var.extra_cloud_config_config
  extra_block_device_mappings = var.extra_block_device_mappings
  asg                         = var.asg
  spot                        = var.spot
  extra_security_group_ids    = var.extra_security_group_ids
  metadata_options            = var.metadata_options
  cluster_data                = module.rke2.cluster_data
  rke2_channel                = var.rke2_channel
  rke2_version                = var.rke2_version
  rke2_config                 = var.rke2_config
  enable_ccm                  = var.enable_ccm
  enable_autoscaler           = var.enable_autoscaler
  download                    = var.download
  pre_userdata                = var.pre_userdata
  post_userdata               = var.post_userdata
  wait_for_capacity_timeout   = var.wait_for_capacity_timeout
  ccm_external                = var.ccm_external
  rke2_start                  = var.rke2_start
  rke2_install_script_url     = var.rke2_install_script_url
  awscli_url                  = var.awscli_url
  unzip_rpm_url               = var.unzip_rpm_url
}
