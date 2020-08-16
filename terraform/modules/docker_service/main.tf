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

  labels = merge(var.labels, local.base_lables)

  task_spec {
    container_spec {
      image   = var.image
      args    = var.args
      command = var.command
      env     = var.env
      dynamic "mounts" {
        for_each = var.mounts
        content {
          target = mounts.value.target
          source = lookup(mounts.value, "source", null)
          type   = lookup(mounts.value, "type", null)
        }
      }
      dynamic "configs" {
        for_each = var.configs
        content {
          config_id = configs.value.config_id
          file_name = configs.value.file_name
        }
      }
    }

    # networks = ["${var.network_id}"]
  }

  endpoint_spec {
    dynamic "ports" {
      for_each = var.ports
      content {
        target_port    = ports.value
        published_port = ports.value
      }
    }
  }
}
