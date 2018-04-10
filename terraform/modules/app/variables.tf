variable public_key_path {
  description = "Path to the public key used to connect to instance"
}

variable private_key_path {
  description = "Path to the private key used to connect to instance"
}

variable zone {
  description = "Zone"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable env_name {
  description = "Type of env. to be created: prod/stage/..."
  default     = ""
}

variable db_ip {
  description = "ip address of the instacne with mongodb"
}

variable deploy_app {
  description = "yes/no"
  default     = "no"
}
