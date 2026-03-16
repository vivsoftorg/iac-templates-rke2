provider "aws" {
  default_tags {
    tags = {
      Project = "ENBUILD"
    }
  }
}

provider "helm" {
  kubernetes = var.enable_cluster_storage_addons ? {
    config_path = "/tmp/${var.cluster_name}-rke2-kubeconfig.yaml"
  } : null
}

provider "kubernetes" {
  config_path = var.enable_cluster_storage_addons ? "/tmp/${var.cluster_name}-rke2-kubeconfig.yaml" : null
}
