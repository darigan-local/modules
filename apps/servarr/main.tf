resource "random_password" "api_key" {
  length = 20
  special = false
}

resource "kubernetes_deployment" "servarr" {

  depends_on = [ random_password.api_key ]

  metadata {
    namespace = var.model.namespace
    name = var.model.name
    labels = {
      app = var.model.name
    }
  }

  spec {
    replicas = var.model.replicas

    selector {
      match_labels = {
        app = var.model.name
      }
    }

    template {
      metadata {
        namespace = var.model.namespace
        labels = {
          app = var.model.name
        }
      }



      spec {
        container {
          name = var.model.name
          image = var.model.image

          dynamic "port" {
            for_each = var.model.ports
            content {
              protocol = port.value.protocol
              container_port = port.value.internal
            }
          }

          // Setting Volume Mounts
          dynamic "volume_mount" {
            for_each = var.model.volumes
            content {
              name = volume_mount.value.name
              mount_path = volume_mount.value.mount_path
            }
          }

          dynamic "volume_mount" {
            for_each = var.model.persistent_volumes
            content {
              name = volume_mount.value.name
              mount_path = volume_mount.value.mount_path
            }
          }

          dynamic "env" {
            for_each = var.model.env
            content {
              name = env.value.name
              value = env.value.value
            }
          }


          env {
            name = "${upper(var.model.name)}__AUTH_APIKEY"
            value = random_password.api_key.result
          }
        }

        // Hosting Volumes
        dynamic "volume" {
          for_each = var.model.volumes
          content {
            name = volume.value.name
            host_path {
              path = volume.value.host_path
            }
          }
        }

        dynamic "volume" {
          for_each = var.model.persistent_volumes
          content {
            name = volume.value.name
            persistent_volume_claim {
              claim_name = volume.value.claim_name
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "servarr" {
  metadata {
    namespace = var.model.namespace
    name = var.model.name

    annotations = {
      "tailscale.com/expose": var.model.tailscale
    }
  }
  spec {
    selector = {
      app = var.model.name
    }

    dynamic "port" {
      for_each = var.model.ports
      content {
        name = port.value.name
        protocol = port.value.protocol
        target_port = port.value.internal
        port = port.value.external
        node_port = port.value.node
      }
    }
    type = var.model.service_type
  }

  wait_for_load_balancer = true
}
