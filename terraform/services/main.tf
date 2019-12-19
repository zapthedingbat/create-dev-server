resource "docker_network" "public_network" {
  name       = "public-network"
  attachable = true
  driver     = "overlay"
}

module "traefik" {
  source = "./traefik"

  domain       = var.domain
  network_name = docker_network.public_network.name
  network_id   = docker_network.public_network.id
}

# module "portainer" {
#   source = "./portainer"

#   admin_password_hash = var.portainer_admin_password_hash
#   domain              = var.domain
#   network_name        = docker_network.public_network.name
#   network_id          = docker_network.public_network.id
# }
