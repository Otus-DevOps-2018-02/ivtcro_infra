resource "google_compute_instance" "db" {
  name         = "reddit-db-${var.env_name}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-db-${var.env_name}", "reddit-${var.env_name}"]

  boot_disk {
    initialize_params {
      image = "${var.db_disk_image}"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}
  }

  metadata {
    ssh-keys = "ivtcro:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    user        = "ivtcro"
    agent       = false
    timeout     = "3m"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    script = "${path.module}/files/mongo_changeBindIP.sh"
  }
}

resource "google_compute_firewall" "firewall_mongo" {
  name    = "allow-mongo-default-${var.env_name}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  # правило применимо к инстансам с тегом ...
  target_tags = ["reddit-db-${var.env_name}"]

  # порт будет доступен только для инстансов с тегом ...
  source_tags = ["reddit-app-${var.env_name}"]
}
