# provider "kubernetes" {
#   config_path = "~/.kube/config"
# }

# module "pv_pvc" {
#   source = "./pv-pvc-module/"

#   pv_name        = var.pv_name
#   pvc_name       = var.pvc_name
#   storage_size   = var.storage_size
#   access_mode    = var.access_mode
#   storage_class  = var.storage_class
# }

# output "pv_name" {
#   value = module.pv_pvc.pv_name
# }

# output "pvc_name" {
#   value = module.pv_pvc.pvc_name
# }

resource "kubernetes_persistent_volume" "pv_example" {
  metadata {
    name = "my-eks-pv"
  }
  spec {
    capacity = {
      storage = "1Gi"
    }
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = "gp3"
    persistent_volume_source {
      aws_elastic_block_store {
        volume_id = "vol-02177252d135889ef" #"vol-07563d615895a7c39"
      }
    }
    # host_path {
    #   path = "/mnt/data"
    # }
  }
}

resource "kubernetes_persistent_volume_claim" "pvc_example" {
  metadata {
    name = "my-eks-pvc"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    storage_class_name = "gp3"
    volume_name        = kubernetes_persistent_volume.pv_example.metadata.0.name
    selector {
      match_labels = {
        type = "my-eks-pv"
      }
    }
  }
}

resource "aws_ebs_volume" "gp3" {
  availability_zone = "us-west-1a"
  size              = 40
  type              = "gp3"
  encrypted         = true

  tags = {
    Name = "gp3"
  }
}
