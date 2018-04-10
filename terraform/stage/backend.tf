terraform {
  backend "gcs" {
    bucket = "reddit-app-storage-bucket-stage"
    prefix = "terraform/state"
  }
}
