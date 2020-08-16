resource "docker_volume" "letsencrypt" {
  name = "letsencrypt"
}

module "service" {
  source     = "../../modules/docker_service"
  network_id = var.network_id
  dns-name   = "traefik"
  domain     = var.domain
  image      = "traefik:v2.3"
  port       = 80
  labels = {
    "traefik.http.routers.traefik.service"                             = "api@internal"
    "traefik.http.middlewares.redirect-to-https.redirectscheme.scheme" = "https"
    "traefik.http.routers.http-catchall.entrypoints"                   = "http"
    "traefik.http.routers.http-catchall.middlewares"                   = "redirect-to-https@docker"
    "traefik.http.routers.http-catchall.rule"                          = "hostregexp(`{host:.+}`)"
  }
  ports = [80, 443]
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
  env = {
    GANDIV5_API_KEY: "${var.gandi_token}"
  }
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
