terraform {
  backend "gcs" {
    bucket = "reddit-app-storage-bucket-prod"
    prefix = "terraform/state"
  }
}
