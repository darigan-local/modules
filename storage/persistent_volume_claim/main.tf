resource "kubernetes_persistent_volume_claim_v1" "app-config-pvc" {
  metadata {
    name      = var.model.name
    namespace = var.model.namespace
  }

  spec {
    # This references the default k3s local-path StorageClass
    storage_class_name = var.model.storage_class
    access_modes       = var.model.access_modes
    resources {
      requests = {
        storage = var.model.storage
      }
    }
  }

  wait_until_bound = var.model.wait_until_bound
}

variable "model" {
  type = object({
    name = string
    namespace = string
    storage_class = string
    access_modes = list(string)
    storage = string
    wait_until_bound = bool
  })
}

