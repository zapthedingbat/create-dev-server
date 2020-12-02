resource "docker_volume" "portainer" {
  name = "portainer"
}

module "service" {
  source     = "../../modules/docker_service"
  network_id = var.network_id
  dns-name   = "portainer"
  domain     = var.domain
  image      = "portainer/portainer-ce:2.0.0-alpine"
  port       = 9000
  ports      = [9000]
  args = [
    "--admin-password=${var.admin_password_hash}",
    "--no-analytics",
    "--no-snapshot",
    "--host", "unix:///var/run/docker.sock",
    "--templates", "https://raw.githubusercontent.com/zapthedingbat/create-dev-server/master/templates/templates.json"
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
