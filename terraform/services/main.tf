resource "docker_network" "public_ingress_network" {
  name       = "public-ingress-network"
  attachable = true
  ingress    = true
  driver     = "overlay"
}

module "traefik" {
  source = "./traefik"

  domain       = var.domain
  network_name = docker_network.public_ingress_network.name
  network_id   = docker_network.public_ingress_network.id
}
