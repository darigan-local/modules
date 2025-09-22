output "app" {
  value = {
    ip = kubernetes_service.servarr.spec[0].cluster_ip
    port = var.model.ports[0].internal
    node_port = var.model.ports[0].node
    api_key = random_password.api_key.result
  }
  sensitive = true
  depends_on = [ kubernetes_service.servarr, random_password.api_key ]
}

output service_name {
  value = kubernetes_service.servarr.metadata[0].name
}