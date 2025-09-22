output "claim_name" {
  value = kubernetes_persistent_volume_claim_v1.app-config-pvc.metadata[0].name
}