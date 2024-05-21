# Nodepool Variables

variable "asg" {
  description = "Node pool AutoScalingGroup scaling definition"
  type = object({
    min                  = number
    max                  = number
    desired              = number
    suspended_processes  = optional(list(string))
    termination_policies = optional(list(string))
  })

  default = {
    min                  = 1
    max                  = 10
    desired              = 1
    suspended_processes  = []
    termination_policies = ["Default"]
  }
}

variable "spot" {
  description = "Toggle spot requests for node pool"
  type        = bool
  default     = false
}

variable "extra_security_group_ids" {
  description = "List of additional security group IDs"
  type        = list(string)
  default     = []
}

variable "metadata_options" {
  type = map(any)
  default = {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # IMDS-v2
    http_put_response_hop_limit = 2          # allow pods to use IMDS as well
    instance_metadata_tags      = "disabled"
  }
  description = "Instance Metadata Options"
}