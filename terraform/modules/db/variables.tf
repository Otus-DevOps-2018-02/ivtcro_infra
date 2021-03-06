variable public_key_path {
  description = "Path to the public key used to connect to instance"
}

variable private_key_path {
  description = "Path to the private key used to connect to instance"
}

variable zone {
  description = "Zone"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable env_name {
  description = "Type of env. to be created: prod/stage/..."
  default     = ""
}

variable deploy_app {
  description = "yes/no"
  default     = "no"
}
