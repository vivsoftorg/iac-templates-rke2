variable "cluster_name" {
  description = "Name of the rkegov cluster to create"
  type        = string
}

variable "unique_suffix" {
  description = "Enables/disables generation of a unique suffix to cluster name"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID to create resources in"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs to create resources in"
  type        = list(string)
}

variable "tags" {
  description = "Map of tags to add to all resources created"
  default     = {}
  type        = map(string)
}

variable "associate_public_ip_address" {
  default = false
  type    = bool
}

variable "pre_userdata" {
  description = "Custom userdata to run immediately before rke2 node attempts to join cluster, after required rke2, dependencies are installed"
  type        = string
  default     = <<EOF
# Disable Incompatible Services

NM_CLOUD_SETUP_SERVICE_ENABLED=`systemctl status nm-cloud-setup.service | grep -i enabled`
NM_CLOUD_SETUP_TIMER_ENABLED=`systemctl status nm-cloud-setup.timer | grep -i enabled`

if [ "$NM_CLOUD_SETUP_SERVICE_ENABLED" ]
then 
  systemctl disable nm-cloud-setup.service
fi

if [ "$NM_CLOUD_SETUP_TIMER_ENABLED" ]
then 
  systemctl disable nm-cloud-setup.timer
fi
EOF
}

variable "post_userdata" {
  description = "Custom userdata to run immediately after rke2 node attempts to join cluster"
  type        = string
  default     = ""
}

#
# Server pool variables
#
variable "instance_type" {
  type        = string
  default     = "t3a.medium"
  description = "Server pool instance type"
}


variable "iam_instance_profile" {
  description = "Server pool IAM Instance Profile, created if left blank (default behavior)"
  type        = string
  default     = ""
}

variable "iam_permissions_boundary" {
  description = "If provided, the IAM role created for the servers will be created with this permissions boundary attached."
  type        = string
  default     = null
}

variable "block_device_mappings" {
  description = "Server pool block device mapping configuration"
  type        = map(string)
  default = {
    "size"      = 30
    "encrypted" = false
  }
}

variable "extra_block_device_mappings" {
  description = "Used to specify additional block device mapping configurations"
  type        = list(map(string))
  default = [
  ]
}

variable "servers" {
  description = "Number of servers to create"
  type        = number
  default     = 1
}

variable "spot" {
  description = "Toggle spot requests for server pool"
  type        = bool
  default     = false
}

variable "ssh_authorized_keys" {
  description = "Server pool list of public keys to add as authorized ssh keys"
  type        = list(string)
  default     = []
}

variable "extra_security_group_ids" {
  description = "List of additional security group IDs"
  type        = list(string)
  default     = []
}

#
# Controlplane Variables
#
variable "controlplane_enable_cross_zone_load_balancing" {
  description = "Toggle between controlplane cross zone load balancing"
  default     = true
  type        = bool
}

variable "controlplane_internal" {
  description = "Toggle between public or private control plane load balancer"
  default     = true
  type        = bool
}

variable "controlplane_allowed_cidrs" {
  description = "Server pool security group allowed cidr ranges"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

#
# RKE2 Variables
#
variable "rke2_version" {
  description = "Version to use for RKE2 server nodes"
  type        = string
  default     = "v1.19.7+rke2r1"
}

variable "rke2_config" {
  description = "Server pool additional configuration passed as rke2 config file, see https://docs.rke2.io/install/install_options/server_config for full list of options"
  type        = string
  default     = ""
}

variable "download" {
  description = "Toggle best effort download of rke2 dependencies (rke2 and aws cli), if disabled, dependencies are assumed to exist in $PATH"
  type        = bool
  default     = true
}

variable "enable_ccm" {
  description = "Toggle enabling the cluster as aws aware, this will ensure the appropriate IAM policies are present"
  type        = bool
  default     = false
}

variable "nodepool_name" {
  description = "Nodepool name"
  type        = string
}

variable "nodepool_instance_type" {
  description = "Node pool instance type"
  default     = "t3.medium"
}


#
# Nodepool Variables
#
variable "nodepool_iam_instance_profile" {
  description = "Node pool IAM Instance Profile, created if left blank (default behavior)"
  type        = string
  default     = ""
}

variable "nodepool_iam_permissions_boundary" {
  description = "If provided, the IAM role created for the nodepool will be created with this permissions boundary attached."
  type        = string
  default     = null
}

variable "nodepool_ssh_authorized_keys" {
  description = "Node pool list of public keys to add as authorized ssh keys, not required"
  type        = list(string)
  default     = []
}

variable "nodepool_block_device_mappings" {
  description = "Node pool block device mapping configuration"
  type        = map(string)

  default = {
    "size" = 30
    type   = "gp2"
  }
}

variable "nodepool_asg" {
  description = "Node pool AutoScalingGroup scaling definition"
  type = object({
    min                  = number
    max                  = number
    desired              = number
    termination_policies = list(string)
  })

  default = {
    min     = 1
    max     = 10
    desired = 1
    termination_policies = ["Default"]
  }
}

variable "nodepool_spot" {
  description = "Toggle spot requests for node pool"
  type        = bool
  default     = false
}


variable "nodepool_enable_autoscaler" {
  description = "Toggle configure the nodepool for cluster autoscaler, this will ensure the appropriate IAM policies are present, you are still responsible for ensuring cluster autoscaler is installed"
  type        = bool
  default     = false
}


variable "wait_for_capacity_timeout" {
  description = "How long Terraform should wait for ASG instances to be healthy before timing out."
  type        = string
  default     = "10m"
}


variable "controlplane_access_logs_bucket" {
  description = "Bucket name for logging requests to control plane load balancer"
  type        = string
  default     = "disabled"
}