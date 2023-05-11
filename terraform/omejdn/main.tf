variable "domain" {
  default = "example.com"
}

resource "helm_release" "omejdn-server" {
  name       = "omejdn-server"

  repository = "../helm"
  chart      = "omejdn-server"

  namespace = "omejdn-daps"
  create_namespace = true

  values = [
    "${file("../helm/omejdn-server/values.yaml")}"
  ]

  set {
    name  = "omejdn.issuer"
    value = "https://daps.${var.domain}/auth"
  }
  set {
    name  = "omejdn.frontUrl"
    value = "https://daps.${var.domain}/auth"
  }
}

resource "helm_release" "omejdn-ui" {
  name       = "omejdn-ui"

  repository = "../helm"
  chart      = "omejdn-ui"

  namespace = "omejdn-daps"
  create_namespace = true

  values = [
    "${file("../helm/omejdn-ui/values.yaml")}"
  ]

  set {
    name  = "omejdn.issuer"
    value = "https://daps.${var.domain}/auth"
  }
}

resource "helm_release" "omejdn-nginx" {
  name       = "omejdn-nginx"

  repository = "../helm"
  chart      = "omejdn-nginx"

  namespace = "omejdn-daps"
  create_namespace = true

  values = [
    "${file("../helm/omejdn-nginx/values.yaml")}"
  ]


  set {
    name  = "nginx.domain"
    value = "daps.${var.domain}"
  }
  set {
    name  = "ingress.hosts[0].host"
    value = "daps.${var.domain}"
  }
  set {
    name  = "ingress.tls[0].hosts[0]"
    value = "daps.${var.domain}"
  }
}
