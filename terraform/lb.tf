resource "google_compute_instance_group" "reddit" {
  name        = "reddit-lb"
  description = "reddit instances' group"

  instances = [
    "${google_compute_instance.app.self_link}",
  ]

  named_port {
    name = "http"
    port = "9292"
  }

  zone = "europe-west1-b"
}