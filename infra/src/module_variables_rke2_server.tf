variable "cluster_name" {
  description = "Name of the rkegov cluster to create"
  type        = string
}

variable "unique_suffix" {
  description = "Enables/disables generation of a unique suffix to cluster name"
  type        = bool
  default     = false
}

variable "lb_subnets" {
  description = "List of subnet IDs to create load balancer in"
  default     = null
  type        = list(string)
}



variable "servers" {
  description = "Number of servers to create"
  type        = number
  default     = 3
}

variable "suspended_processes" {
  description = "List of processes to suspend in the autoscaling service"
  type        = list(string)
  default     = []
}

variable "termination_policies" {
  description = "List of policies to decide how the instances in the Auto Scaling Group should be terminated"
  type        = list(string)
  default     = ["Default"]
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

variable "controlplane_access_logs_bucket" {
  description = "Bucket name for logging requests to control plane load balancer"
  type        = string
  default     = "disabled"
}

variable "associate_public_ip_address" {
  default = null
  type    = bool
}

### Statestore Variables
variable "statestore_attach_deny_insecure_transport_policy" {
  description = "Toggle for enabling s3 policy to reject non-SSL requests"
  type        = bool
  default     = true
}

variable "create_acl" {
  description = "Toggle creation of ACL for statestore bucket"
  type        = bool
  default     = true
}
