module "services" {
  source = "../modules/docker_service"

  dns-name = "traefik"
  domain   = var.domain
  image    = "traefik:v2.1.1"
  port     = 1234
  labels = {
    "traefik.http.middlewares.redirect-to-https.redirectscheme.scheme" = "https"
    "traefik.http.routers.api.service"                                 = "api@internal"
    "traefik.http.routers.http-catchall.entrypoints"                   = "http"
    "traefik.http.routers.http-catchall.middlewares"                   = "redirect-to-https@docker"
    "traefik.http.routers.http-catchall.rule"                          = "hostregexp(`{host:.+}`)"
    "traefik.http.services.placeholder.loadbalancer.server.port"       = "1234"
  }
  ports = [80, 443]
}
