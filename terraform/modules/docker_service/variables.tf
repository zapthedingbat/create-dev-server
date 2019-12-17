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
