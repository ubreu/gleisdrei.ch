variable "project" {
	description = "GCP Project ID"
	type = string
	default = "gleisdrei-site"
}

variable "region" {
	description = "GCP Region"
	type = string
	default = "europe-west6"
}

variable "services" {
    type = list(string)
    default = ["compute.googleapis.com"]
}