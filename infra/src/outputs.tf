output "vpc" {
  value = module.vpc
}

output "rke2" {
  value = module.rke2
}

# Example method of fetching kubeconfig from state store, requires aws cli and bash locally
resource "null_resource" "kubeconfig" {
  depends_on = [module.rke2]

  # Use a trigger to make sure the local-exec provisioner is executed on each apply
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "aws s3 cp ${module.rke2.kubeconfig_path} target/rke2.yaml"
  }
}