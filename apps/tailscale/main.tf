resource "helm_release" "tailscale" {
  name  = var.model.name
  chart = var.model.chart
  repository = var.model.repository
  namespace = var.model.namespace
  create_namespace = var.model.create_namespace

  set {
    name = "oauth.clientId"
    value = var.oauthClientId
  }

  set {
    name = "oauth.clientSecret"
    value = var.oauthClientSecret
  }
}