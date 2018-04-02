output "app_external_ip_1" {
  value = "${google_compute_instance.app.*.network_interface.0.access_config.0.assigned_nat_ip[0]}"
}

output "app_external_ip_2" {
  value = "${google_compute_instance.app.*.network_interface.0.access_config.0.assigned_nat_ip[1]}"
}

output "app_external_ip_on_lb" {
  value = "${google_compute_global_forwarding_rule.reddit_app_forwarding_rule.ip_address}"
}
