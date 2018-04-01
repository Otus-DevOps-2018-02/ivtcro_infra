output reddit-db-instance-int-ip {
  value = "${google_compute_instance.db.network_interface.0.address}"
}
