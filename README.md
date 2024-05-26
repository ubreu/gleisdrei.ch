# Website for gleisdrei.ch

## Setup

- https://cloud.google.com/storage/docs/hosting-static-website

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