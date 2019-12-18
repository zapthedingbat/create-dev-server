resource "docker_volume" "letsencrypt" {
  name = "letsencrypt"
}

module "service" {
  source     = "../../modules/docker_service"
  network_id = var.network_id
  dns-name   = "traefik"
  domain     = var.domain
  image      = "traefik:v2.1.1"
  port       = 1234
  labels = {
    "traefik.http.middlewares.redirect-to-https.redirectscheme.scheme" = "https"
    "traefik.http.routers.api.service"                                 = "api@internal"
    "traefik.http.routers.http-catchall.entrypoints"                   = "http"
    "traefik.http.routers.http-catchall.middlewares"                   = "redirect-to-https@docker"
    "traefik.http.routers.http-catchall.rule"                          = "hostregexp(`{host:.+}`)"
    "traefik.http.services.placeholder.loadbalancer.server.port"       = "1234"
  }
  ports   = [80, 443]
  command = [""]
  args = [
    "--providers.docker.endpoint=unix:///var/run/docker.sock",
    "--providers.docker.swarmMode=true",
    "--providers.docker.exposedbydefault=false",
    "--providers.docker.network=${var.network_name}",
    "--entrypoints.http.address=:80",
    "--entrypoints.https.address=:443",
    "--certificatesResolvers.le-dns.acme.dnsChallenge=true",
    "--certificatesResolvers.le-dns.acme.dnsChallenge.provider=gandiv5",
    "--certificatesResolvers.le-dns.acme.dnsChallenge.delayBeforeCheck=5",
    "--certificatesResolvers.le-dns.acme.email=test@${var.domain}",
    "--certificatesresolvers.le-dns.acme.storage=/letsencrypt/acme-dns.json",
    "--api=true",
    "--api.dashboard=true",
    "--log.level=WARN"
  ]
  mounts = [
    {
      target = "/var/run/docker.sock"
      source = "/var/run/docker.sock"
      type   = "bind"
    },
    {
      target = "/letsencrypt"
      source = "${docker_volume.letsencrypt.name}"
      type   = "volume"
    }
  ]
}
