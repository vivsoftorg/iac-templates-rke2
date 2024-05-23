provider "aws" {
  default_tags {
    tags = {
      Project = "ENBUILD"
    }
  }
}

provider "kubernetes" {
  config_path = "${var.target_path}/${var.cluster_name}-rke2-kubeconfig.yaml"
}


provider "helm" {
  kubernetes {
    config_path = "${var.target_path}/${var.cluster_name}-rke2-kubeconfig.yaml"
  }
}