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

# Private Key
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "pem" {
  filename        = "${var.cluster_name}.pem"
  content         = tls_private_key.ssh.private_key_pem
  file_permission = "0600"
}

# Provision rke2 server(s) and controlplane loadbalancer
module "rke2" {
  source = "./modules/rke2-aws-tf/"
  // source                                        = "git::https://github.com/rancherfederal/rke2-aws-tf.git?ref=v2.5.0"
  cluster_name                                  = var.cluster_name
  unique_suffix                                 = var.unique_suffix
  vpc_id                                        = var.vpc_id
  subnets                                       = var.subnets
  tags                                          = var.tags
  instance_type                                 = var.instance_type
  ami                                           = data.aws_ami.rhel8.image_id
  iam_instance_profile                          = var.iam_instance_profile
  iam_permissions_boundary                      = var.iam_permissions_boundary
  block_device_mappings                         = var.block_device_mappings
  extra_block_device_mappings                   = var.extra_block_device_mappings
  servers                                       = var.servers
  spot                                          = var.spot
  ssh_authorized_keys                           = [tls_private_key.ssh.public_key_openssh]
  extra_security_group_ids                      = var.extra_security_group_ids
  controlplane_enable_cross_zone_load_balancing = var.controlplane_enable_cross_zone_load_balancing
  controlplane_internal                         = var.controlplane_internal
  controlplane_allowed_cidrs                    = var.controlplane_allowed_cidrs
  controlplane_access_logs_bucket               = var.controlplane_access_logs_bucket
  associate_public_ip_address                   = var.associate_public_ip_address
  rke2_version                                  = var.rke2_version
  rke2_config                                   = var.rke2_config
  download                                      = var.download
  pre_userdata                                  = var.pre_userdata
  post_userdata                                 = var.post_userdata
  enable_ccm                                    = var.enable_ccm
  wait_for_capacity_timeout                     = var.wait_for_capacity_timeout
}

# Provision Auto Scaling Group of agents to auto-join cluster
module "rke2_agents" {
  source = "./modules/rke2-aws-tf/modules/agent-nodepool/"
  // source                      = "git::https://github.com/rancherfederal/rke2-aws-tf.git//modules/agent-nodepool?ref=v2.5.0"
  name                        = var.nodepool_name
  vpc_id                      = var.vpc_id
  subnets                     = var.subnets
  instance_type               = var.nodepool_instance_type
  ami                         = data.aws_ami.rhel8.image_id
  tags                        = var.tags
  iam_instance_profile        = var.nodepool_iam_instance_profile
  iam_permissions_boundary    = var.nodepool_iam_permissions_boundary
  ssh_authorized_keys         = [tls_private_key.ssh.public_key_openssh]
  block_device_mappings       = var.block_device_mappings
  extra_block_device_mappings = var.extra_block_device_mappings
  asg                         = var.nodepool_asg
  spot                        = var.nodepool_spot
  extra_security_group_ids    = var.extra_security_group_ids
  cluster_data                = module.rke2.cluster_data # Required input sourced from parent rke2 module, contains configuration that agents use to join existing cluster
  rke2_version                = var.rke2_version
  rke2_config                 = var.rke2_config
  enable_ccm                  = var.enable_ccm
  enable_autoscaler           = var.nodepool_enable_autoscaler
  download                    = var.download
  pre_userdata                = var.pre_userdata
  post_userdata               = var.post_userdata
  wait_for_capacity_timeout   = var.wait_for_capacity_timeout
}
