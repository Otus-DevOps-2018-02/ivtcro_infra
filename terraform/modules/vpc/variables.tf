variable source_ranges {
  description = "Allowed IP addresses"
  default     = ["0.0.0.0/0"]
}

variable env_name {
  description = "Type of env. to be created: prod/stage/..."
  default     = ""
}
