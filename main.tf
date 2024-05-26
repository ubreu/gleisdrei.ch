provider "google" {
  project = var.project
  region  = var.region
}

resource "google_project_service" "project" {
  for_each = toset(var.services)
  project = var.project
  service = each.value

  disable_dependent_services = true
}

resource "google_compute_project_default_network_tier" "default" {
  network_tier = "STANDARD"
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
  }
  depends_on = [google_project_service.project]
}

resource "google_storage_bucket_iam_member" "all_users" {
  bucket = google_storage_bucket.static_website.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_storage_bucket_object" "site" {
  for_each     = fileset("site/dist/site/browser", "*")
  source       = "site/dist/site/browser/${each.value}"
  name         = "${each.value}"
  content_type = lookup(var.content_type, split(".", each.value)[1], "text/plain; charset=utf-8")
  bucket       = google_storage_bucket.static_website.name
}

resource "google_compute_backend_bucket" "site_bucket" {
  name        = "site-backend-bucket"
  bucket_name = google_storage_bucket.static_website.name
}

resource "google_compute_managed_ssl_certificate" "lb_default" {
  provider = google-beta
  project  = var.project
  name     = "site-ssl-cert"

  managed {
    domains = ["gleisdrei.ch"]
  }
}

resource "google_compute_url_map" "default" {
  name            = "site-lb"
  default_service = google_compute_backend_bucket.site_bucket.id
}

resource "google_compute_target_https_proxy" "default" {
  name    = "site-proxy"
  url_map = google_compute_url_map.default.id
  ssl_certificates = [
    google_compute_managed_ssl_certificate.lb_default.name
  ]
  depends_on = [
    google_compute_managed_ssl_certificate.lb_default
  ]
}

resource "google_compute_forwarding_rule" "default" {
  name                  = "site-lb-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443"
  target                = google_compute_target_https_proxy.default.id
}