variable "dns-name" {
  type = string
}

variable "domain" {
  type = string
}

variable "image" {
  type = string
}

variable "port" {
  type = number
}

variable "labels" {
  type = map(string)

  default = {}
}

variable "ports" {
  type = list(number)

  default = []
}

variable "command" {
  type = list(string)
}

variable "args" {
  type = list(string)
}

variable "network_id" {
  type = string
}

variable "mounts" {
  type = list(object({
    target = string
    source = string
    type   = string
  }))

  default = []
}
