provider "google" {
  project = var.project
  region  = var.region
}

resource "google_project_service" "project" {
  for_each = toset(var.services)
  project = var.project
  service = each.value
}

resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "static_website" {
  name          = "${random_id.bucket_prefix.hex}-static-website-bucket"
  location      = var.region
  storage_class = "STANDARD"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}