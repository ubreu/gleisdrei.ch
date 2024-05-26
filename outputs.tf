output "website_bucket" {
  value = google_storage_bucket.static_website.url
}

output "ssl_certificate" {
  value = google_compute_managed_ssl_certificate.lb_default.name
}

output "lb_ip_address" {
  value = google_compute_target_https_proxy.default.name
}