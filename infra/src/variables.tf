variable "vpc_cidr" {
  description = "The IPv4 CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "create_registry1_mirror" {
  description = "Should we add the registry1 mirror to the EKS cluster nodes"
  type        = bool
  default     = false
}

variable "registry1_mirror_proxy_address" {
  description = "The address of the registry1 mirror proxy, if the registry1 mirror is enabled by setting the create_registry1_mirror"
  type        = string
  default     = "http://44.210.192.97:5000"
}

variable "enable_sops" {
  description = "Should we enable SOPS for secrets management"
  type        = bool
  default     = true
}

variable "target_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "/tmp/target"
}