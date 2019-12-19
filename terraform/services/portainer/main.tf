resource "docker_volume" "portainer" {
  name = "portainer"
}

data "template_file" "portainer_templates_tpl" {
  template = "${file("templates/templates.json.tpl")}"

  vars {
    domain = var.domain
  }
}

resource "docker_secret" "portainer_admin_secret" {
  name = "admin-secret"
  data = "${base64encode(var.admin_password_hash)}"
}

resource "docker_config" "portainer_templates" {
  name = "portainer-templates-${replace(timestamp(), ":", ".")}"
  data = "${base64encode(data.template_file.portainer_templates_tpl.rendered)}"

  lifecycle {
    ignore_changes        = ["name"]
    create_before_destroy = true
  }
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
  configs = [
    {
      config_id = "${docker_config.portainer_templates.id}"
      file_name = "/templates.json"
    },
  ]
}
