resource "google_compute_instance" "app" {
  name         = "reddit-app-${var.env_name}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app-${var.env_name}", "reddit-${var.env_name}"]

  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  metadata {
    ssh-keys = "ivtcro:${file(var.public_key_path)}"
  }
}

locals {
  app_external_ip = "${google_compute_instance.app.network_interface.0.access_config.0.assigned_nat_ip}"
}

resource "null_resource" "deploy_app" {
  count = "${var.deploy_app == "yes" ? 1 : 0}"

  triggers {
    app_instance_id = "${google_compute_instance.app.id}"
  }

  connection {
    host        = "${local.app_external_ip}"
    type        = "ssh"
    user        = "ivtcro"
    agent       = false
    timeout     = "3m"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    content     = "${data.template_file.puma_unit_file.rendered}"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "${path.module}/files/deploy.sh"
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]

  # Правило применимо для инстансов с тегом …
  target_tags = ["reddit-app-${var.env_name}"]
}

resource "google_compute_firewall" "ngnix_http" {
  name = "allow-ngnix-http"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]

  # Правило применимо для инстансов с тегом …
  target_tags = ["reddit-app-${var.env_name}"]
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip-${var.env_name}"
}

data "template_file" "puma_unit_file" {
  template = "${file("${path.module}/files/puma.service")}"

  vars {
    mongodb_host_ip = "${var.db_ip}"
  }
}
