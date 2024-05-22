output "vpc" {
  value = module.vpc
}

output "rke2" {
  value = module.rke2
}

output "kubeconfig" {
  description = "kubeconfig file location"
  value       = "aws s3 cp ${module.rke2.kubeconfig_path} target/rke2.yaml"
}