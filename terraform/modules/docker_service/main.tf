locals {
  base_lables = {
    "traefik.enable"                                                 = "true"
    "traefik.http.routers.${var.dns-name}.entrypoints"               = "https"
    "traefik.http.routers.${var.dns-name}.rule"                      = "Host(`${var.dns-name}.${var.domain}`)"
    "traefik.http.routers.${var.dns-name}.tls.certresolver"          = "le-dns"
    "traefik.http.routers.${var.dns-name}.tls.domains[0].main"       = var.domain
    "traefik.http.routers.${var.dns-name}.tls.domains[0].sans"       = "*.${var.domain}"
    "traefik.http.services.${var.dns-name}.loadbalancer.server.port" = "${var.port}"
  }
}

resource "docker_service" "docker_service" {
  name = var.dns-name

  task_spec {
    container_spec {
      image  = var.image
      labels = merge(var.labels, local.base_lables)
    }
  }

  endpoint_spec {
    dynamic "ports" {
      for_each = var.ports
      content {
        target_port = ports.value
      }
    }
  }
}
