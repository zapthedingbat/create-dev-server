resource "docker_volume" "portainer" {
  name = "portainer"
}

module "service" {
  source     = "../../modules/docker_service"
  network_id = var.network_id
  dns-name   = "portainer"
  domain     = var.domain
  image      = "portainer/portainer:1.23.0"
  port       = 9000
  ports      = [9000]
  args = [
    "-H",
    "unix:///var/run/docker.sock",
    "--admin-password=${var.admin_password_hash}",
    "--no-analytics",
    "--no-snapshot"
  ]
  mounts = [
    {
      target = "/var/run/docker.sock"
      source = "/var/run/docker.sock"
      type   = "bind"
    },
    {
      target = "/data"
      source = "${docker_volume.portainer.name}"
      type   = "volume"
    }
  ]
}
