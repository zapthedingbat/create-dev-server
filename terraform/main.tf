provider "docker" {
  version = "=2.7.2"
  host = "ssh://${var.docker_ssh_user}@${var.docker_ssh_host}:${var.docker_ssh_port}"
}

terraform {
  required_version = ">= 0.12.18, < 0.13"
  # Use partial configuration for S3 backend
  # https://www.terraform.io/docs/backends/config.html#partial-configuration
  backend "remote" {
    # Using free terraform cloud. Sign up at https://app.terraform.io/
    hostname = "app.terraform.io"
    workspaces {
      name = "dev-server"
    }
  }
}

module "services" {
  source = "./services"

  domain                        = var.domain
  gandi_token                   = var.gandi_token
  portainer_admin_password_hash = var.portainer_admin_password_hash
}
