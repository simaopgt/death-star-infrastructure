resource "google_cloud_run_v2_service" "command_core" {
  name     = var.command_core_service_name
  location = var.region
  template {
    containers {
      image = var.command_core_image
      ports {
        container_port = 8080
      }
    }
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
  name     = var.bridge_ui_service_name
  location = var.region
  template {
    containers {
      image = var.bridge_ui_image
      ports {
        container_port = 3000
      }
    }
  }
}

resource "google_cloud_run_v2_service_iam_binding" "bridge_ui_public_access" {
  project  = google_cloud_run_v2_service.bridge_ui.project
  location = google_cloud_run_v2_service.bridge_ui.location
  name     = google_cloud_run_v2_service.bridge_ui.name
  role     = "roles/run.invoker"
  members  = ["allUsers"]
}
