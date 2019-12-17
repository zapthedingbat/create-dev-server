variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "docker_ssh_user" {
  type    = string
  default = "automation"
}

variable "docker_ssh_host" {
  type = string
}

variable "docker_ssh_port" {
  type    = number
  default = 22
}

variable "domain" {
  type = string
}
