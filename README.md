# Website for gleisdrei.ch

This repository contains the static assets for gleisdrei.ch and the required Google cloud infrastructure configuration via Terraform.
The setup is based on the following guides & tutorials:
- https://cloud.google.com/storage/docs/hosting-static-website
- https://cloud.google.com/cdn/docs/setting-up-cdn-with-bucket
- https://cloud.google.com/load-balancing/docs/https/ext-load-balancer-backend-buckets

## Setup

### Initialize the gcloud SDK

````
gcloud init
````
This will authorize the SDK to access GCP using your user account credentials and add the SDK to your PATH. This steps requires you to login and select the project you want to work in. Finally, add your account to the Application Default Credentials (ADC). This will allow Terraform to access these credentials to provision resources on GCloud.
````
gcloud auth application-default login
````

### Run terraform

````
terraform plan
terraform apply
````