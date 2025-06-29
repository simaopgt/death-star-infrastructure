#!/bin/bash

# Build and Push Script for Death Star Infrastructure
# Automatiza o build e push das imagens Docker para o Google Artifact Registry

set -e  # Exit on error

# Configurações
PROJECT_ID="death-star-platform-666"
REGION="us-central1"
REGISTRY="${REGION}-docker.pkg.dev"
REPO_NAME="ghcr-remote"
REPOS_DIR="/Users/simaopgt/Projects/Personal/death-star/repos"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Death Star Infrastructure - Build and Push Script${NC}"
echo "=================================================="

# Função para log
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar se Docker está rodando
if ! docker info > /dev/null 2>&1; then
    error "Docker não está rodando. Por favor, inicie o Docker Desktop."
    exit 1
fi

# Configurar autenticação do Docker para Artifact Registry
log "Configurando autenticação do Docker para Artifact Registry..."
gcloud auth configure-docker ${REGISTRY} --quiet

# Array de serviços para build
services=(
    "command-core:death-star-command-core"
    "bridge-ui:death-star-bridge-ui"
)

# Função para build e push de uma imagem
build_and_push() {
    local service_name=$1
    local repo_dir=$2
    local image_tag=${3:-latest}
    
    log "Building ${service_name}..."
    
    # Navegar para o diretório do repositório
    if [ ! -d "${REPOS_DIR}/${repo_dir}" ]; then
        error "Diretório ${REPOS_DIR}/${repo_dir} não encontrado!"
        return 1
    fi
    
    cd "${REPOS_DIR}/${repo_dir}"
    
    # Verificar se Dockerfile existe
    if [ ! -f "Dockerfile" ]; then
        error "Dockerfile não encontrado em ${REPOS_DIR}/${repo_dir}"
        return 1
    fi
    
    # Definir tags da imagem
    local local_tag="project-death-star/${repo_dir}:${image_tag}"
    local registry_tag="${REGISTRY}/${PROJECT_ID}/${REPO_NAME}/project-death-star/${repo_dir}:${image_tag}"
    
    log "Building imagem: ${local_tag}"
    
    # Build da imagem
    if docker build -t "${local_tag}" .; then
        log "✅ Build successful para ${service_name}"
    else
        error "❌ Build failed para ${service_name}"
        return 1
    fi
    
    # Tag para registry
    log "Tagging imagem para registry: ${registry_tag}"
    docker tag "${local_tag}" "${registry_tag}"
    
    # Push para registry
    log "Pushing imagem para Artifact Registry..."
    if docker push "${registry_tag}"; then
        log "✅ Push successful para ${service_name}"
        log "Imagem disponível em: ${registry_tag}"
    else
        error "❌ Push failed para ${service_name}"
        return 1
    fi
    
    echo ""
}

# Build e push de todas as imagens
log "Iniciando build e push das imagens..."
echo ""

for service_pair in "${services[@]}"; do
    service=$(echo $service_pair | cut -d: -f1)
    repo_dir=$(echo $service_pair | cut -d: -f2)
    log "Processando ${service} (${repo_dir})..."
    
    if build_and_push "${service}" "${repo_dir}" "latest"; then
        log "✅ ${service} processado com sucesso"
    else
        error "❌ Falha ao processar ${service}"
        exit 1
    fi
    echo "---"
done

# Listar imagens no registry
log "Listando imagens no Artifact Registry..."
gcloud artifacts docker images list ${REGISTRY}/${PROJECT_ID}/${REPO_NAME} --include-tags

echo ""
log "✅ Build e push concluídos com sucesso!"
log "📦 Imagens disponíveis no registry: ${REGISTRY}/${PROJECT_ID}/${REPO_NAME}"

# Próximos passos
echo ""
echo -e "${YELLOW}📋 Próximos passos:${NC}"
echo "1. Execute: terraform plan (para verificar as mudanças)"
echo "2. Execute: terraform apply (para atualizar os serviços Cloud Run)"
echo ""
echo -e "${GREEN}🎉 Script concluído!${NC}"