resource "google_project" "my_project" {
  name       = "My Project"
  project_id = "golden-union-377614"
  org_id     = "1234567"
}

resource "google_app_engine_application" "app" {
  project     = google_project.my_project.project_id
  location_id = "us-central"
}
resource "google_app_engine_application_url_dispatch_rules" "web_service" {
  dispatch_rules {
    domain  = "*"
    path    = "/*"
    service = "default"
  }

  dispatch_rules {
    domain  = "*"
    path    = "/admin/*"
    service = google_app_engine_standard_app_version.admin_v3.service
  }
}

resource "google_storage_bucket_object" "picture" {
  name   = "butterfly01"
  source = "/images/nature/garden-tiger-moth.jpg"
  bucket = "image-store"
}
resource "google_app_engine_standard_app_version" "admin_v3" {
  version_id = "v3"
  service    = "admin"
  runtime    = "nodejs10"

  entrypoint {
    shell = "node ./app.js"
  }

  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${google_storage_bucket.bucket.name}/${google_storage_bucket_object.object.name}"
    }
  }

  env_variables = {
    port = "8080"
  }

  noop_on_destroy = true
}

resource "google_storage_bucket" "bucket" {
  name     = "appengine-test-bucket"
  location = "US"
}
