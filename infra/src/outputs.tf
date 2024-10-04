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

output "mirror_config" {
  description = "Registry one Mirror config"
  value       = var.create_registry1_mirror ? local.pre_userdata : null
}

output "bigbang_sops_config" {
  value = <<SOPS
  ---
creation_rules:
  - kms: ${aws_kms_key.sops_key[0].arn}
    encrypted_regex: "^(data|stringData)$"
  SOPS
}