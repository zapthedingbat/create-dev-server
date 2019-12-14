# Configure the Docker provider
provider "docker" {
  host = "ssh://${var.docker_ssh_user}@${var.docker_ssh_host}:${var.docker_ssh_port}"
}
