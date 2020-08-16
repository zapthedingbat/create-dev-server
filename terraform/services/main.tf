resource "docker_network" "traefik" {
  name       = "traefik"
  attachable = true
  driver     = "overlay"
}

module "traefik" {
  source = "./traefik"

  domain       = var.domain
  gandi_token  = var.gandi_token
  network_id   = docker_network.traefik.id
  network_name = docker_network.traefik.name
}

module "portainer" {
  source = "./portainer"

  admin_password_hash = var.portainer_admin_password_hash
  domain              = var.domain
  network_id          = docker_network.traefik.id
  network_name        = docker_network.traefik.name
}
