
resource "google_artifact_registry_repository" "standard_repo" {
  project       = var.project_id
  location      = var.region
  repository_id = "death-star-images"
  description   = "Standard Docker repository for Death Star project images"
  format        = "DOCKER"
  mode          = "STANDARD_REPOSITORY"
}
