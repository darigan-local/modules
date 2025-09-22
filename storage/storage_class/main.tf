resource "kubernetes_storage_class_v1" "local_path_retain" {
  metadata {
    name = var.model.name
  }
  storage_provisioner  = var.model.provisioner
  volume_binding_mode  = var.model.volume_binding_mode
  reclaim_policy       = var.model.reclaim_policy
  parameters = {
    hostpath = var.model.hostpath
  }
}



