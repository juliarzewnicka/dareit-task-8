provider "google" {
  project = "golden-union-377614"
  region  = "us-central1"
  zone    = "us-central1-c"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "my-context"
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "my-first-namespace"
  }
}