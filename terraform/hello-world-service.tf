resource "docker_service" "hello-world-service" {
  name = "hello-world-service"

  task_spec {
    container_spec {
      image = "hello-world"
    }
  }
}
