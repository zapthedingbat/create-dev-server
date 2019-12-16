resource "docker_service" "hello_world" {
  name = "hello-world"
  task_spec {
    container_spec {
      image = "hello-world"
    }
  }
}
