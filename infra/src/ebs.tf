resource "helm_release" "ebs_csi_driver" {
  depends_on = [
    null_resource.kubeconfig
  ]

  name       = "ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  version    = "2.30.0"

  namespace        = "kube-system"
  create_namespace = true
}