terraform {
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
