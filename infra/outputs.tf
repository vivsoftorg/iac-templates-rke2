output "cluster_name" {
  description = "Name of the rke2 cluster"
  value       = module.rke2.cluster_name
}

# This output is intentionaly blackboxed from the user, make separate outputs intended for user consumption
output "cluster_data" {
  description = "Map of cluster data required by agent pools for joining cluster, do not modify this"
  value       = module.rke2.cluster_data
}

output "cluster_sg" {
  description = "Security group shared by cluster nodes, this is different than nodepool security groups"
  value       = module.rke2.cluster_sg
}

output "server_url" {
  value = module.rke2.server_url
}

output "server_sg" {
  value = module.rke2.server_sg
}

output "server_nodepool_id" {
  value = module.rke2.server_nodepool_id
}

output "server_nodepool_name" {
  value = module.rke2.server_nodepool_name
}

output "server_nodepool_arn" {
  value = module.rke2.server_nodepool_arn
}

output "iam_role" {
  description = "IAM role of server nodes"
  value       = module.rke2.iam_role
}

output "iam_instance_profile" {
  description = "IAM instance profile attached to server nodes"
  value       = module.rke2.iam_instance_profile
}

output "iam_role_arn" {
  description = "IAM role arn of server nodes"
  value       = module.rke2.iam_role_arn
}

output "kubeconfig_path" {
  value = module.rke2.kubeconfig_path
}

output "nodepool_security_group" {
  value = module.rke2_agents.security_group
}

output "nodepool_name" {
  value = module.rke2_agents.nodepool_name
}

output "nodepool_arn" {
  value = module.rke2_agents.nodepool_arn
}

output "nodepool_id" {
  value = module.rke2_agents.nodepool_id
}

output "nodepool_iam_role" {
  description = "IAM role of node pool"
  value       = module.rke2_agents.iam_role
}

output "nodepool_iam_instance_profile" {
  description = "IAM instance profile attached to nodes in nodepool"
  value       = module.rke2_agents.iam_instance_profile
}

output "nodepool_iam_role_arn" {
  description = "IAM role arn of node pool"
  value       = module.rke2_agents.iam_role_arn
}
