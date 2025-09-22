variable "model" {
  type = object({
    name = string
    provisioner = string
    volume_binding_mode = string
    reclaim_policy = string
    hostpath = string
  })
}
