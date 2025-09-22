variable "oauthClientId" {
  type = string
  sensitive = true
}

variable "oauthClientSecret" {
  type = string
  sensitive = true
}

variable model {
  type = object({
    name = string
    chart = string
    repository = string
    namespace = string
    create_namespace = bool
  })
}
