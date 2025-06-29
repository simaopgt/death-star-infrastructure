resource "google_cloud_run_v2_service" "command_core" {
  project  = var.project_id
  name     = var.command_core_service_name
  location = var.region
  deletion_protection = false
  template {
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.standard_repo.repository_id}/death-star-command-core:4fdabc69118ffb99eb232720f50193f273c90849"
      ports {
        container_port = 8080
      }
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 10
    }
  }
  traffic {
    type = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
}

resource "google_cloud_run_v2_service_iam_binding" "command_core_public_access" {
  project  = google_cloud_run_v2_service.command_core.project
  location = google_cloud_run_v2_service.command_core.location
  name     = google_cloud_run_v2_service.command_core.name
  role     = "roles/run.invoker"
  members  = ["allUsers"]
}

resource "google_cloud_run_v2_service" "bridge_ui" {
  project  = var.project_id
  name     = var.bridge_ui_service_name
  location = var.region
  deletion_protection = false
  template {
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.standard_repo.repository_id}/death-star-bridge-ui:0ec0421ebb36c5de5de541d28417fded12ba8001"
      ports {
        container_port = 3000
      }
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 10
    }
  }
  traffic {
    type = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
}

resource "google_cloud_run_v2_service_iam_binding" "bridge_ui_public_access" {
  project  = google_cloud_run_v2_service.bridge_ui.project
  location = google_cloud_run_v2_service.bridge_ui.location
  name     = google_cloud_run_v2_service.bridge_ui.name
  role     = "roles/run.invoker"
  members  = ["allUsers"]
}
