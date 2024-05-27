provider "aws" {
  default_tags {
    tags = {
      Project = "ENBUILD"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "/tmp/${var.cluster_name}-rke2-kubeconfig.yaml"
  }
}

provider "kubernetes" {
  config_path = "/tmp/${var.cluster_name}-rke2-kubeconfig.yaml"
}