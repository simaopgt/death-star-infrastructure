#!/bin/bash

# Update Terraform Images Script
# Atualiza automaticamente as configurações do Terraform para usar as imagens corretas

set -e

# Configurações
PROJECT_ID="death-star-platform-666"
REGION="us-central1"
REGISTRY="${REGION}-docker.pkg.dev"
REPO_NAME="ghcr-remote"

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🔄 Atualizando configurações do Terraform...${NC}"

# Backup do arquivo atual
cp cloudrun.tf cloudrun.tf.backup
echo -e "${YELLOW}📁 Backup criado: cloudrun.tf.backup${NC}"

# Atualizar cloudrun.tf com as imagens corretas
cat > cloudrun.tf << 'EOF'
resource "google_cloud_run_v2_service" "command_core" {
  project  = var.project_id
  name     = var.command_core_service_name
  location = var.region
  deletion_protection = false
  template {
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.remote_repo.name}/project-death-star/death-star-command-core:latest"
      ports {
        container_port = 8080
      }
      env {
        name  = "PORT"
        value = "8080"
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
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.remote_repo.name}/project-death-star/death-star-bridge-ui:latest"
      ports {
        container_port = 3000
      }
      env {
        name  = "PORT"
        value = "3000"
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
EOF

echo -e "${GREEN}✅ Terraform atualizado para usar imagens customizadas${NC}"
echo -e "${YELLOW}📝 Próximos passos:${NC}"
echo "1. Execute o script de build: ./build-and-push.sh"
echo "2. Execute: terraform plan"
echo "3. Execute: terraform apply"