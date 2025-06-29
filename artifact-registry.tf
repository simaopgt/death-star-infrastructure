resource "google_artifact_registry_repository" "remote_repo" {
  provider      = google-beta
  project       = var.project_id
  location      = var.region
  repository_id = var.artifact_registry_repo_name
  description   = "Remote repository for ghcr.io"
  format        = "DOCKER"
  mode          = "REMOTE_REPOSITORY"
  remote_repository_config {
    docker_repository {
      custom_repository {
        uri = "https://ghcr.io"
      }
    }
  }
}
