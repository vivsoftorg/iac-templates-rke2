resource "helm_release" "ebs_csi_driver" {
  count = var.enable_cluster_storage_addons ? 1 : 0

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

resource "kubernetes_storage_class_v1" "ebs_storageclass" {
  count = var.enable_cluster_storage_addons ? 1 : 0

  depends_on = [
    helm_release.ebs_csi_driver,
    null_resource.kubeconfig
  ]
  metadata {
    name = "ebs-storageclass"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner = "ebs.csi.aws.com"
  volume_binding_mode = "WaitForFirstConsumer"
}
