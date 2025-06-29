#!/bin/bash

# Death Star Infrastructure - Deploy Script
# Script master que automatiza todo o processo de build, push e deploy

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "██████╗ ███████╗ █████╗ ████████╗██╗  ██╗    ███████╗████████╗ █████╗ ██████╗ "
echo "██╔══██╗██╔════╝██╔══██╗╚══██╔══╝██║  ██║    ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗"
echo "██║  ██║█████╗  ███████║   ██║   ███████║    ███████╗   ██║   ███████║██████╔╝"
echo "██║  ██║██╔══╝  ██╔══██║   ██║   ██╔══██║    ╚════██║   ██║   ██╔══██║██╔══██╗"
echo "██████╔╝███████╗██║  ██║   ██║   ██║  ██║    ███████║   ██║   ██║  ██║██║  ██║"
echo "╚═════╝ ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝    ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝"
echo -e "${NC}"
echo -e "${GREEN}🚀 Infrastructure Deployment Script${NC}"
echo "========================================"

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

# Verificar pré-requisitos
check_prerequisites() {
    log "Verificando pré-requisitos..."
    
    # Verificar se Docker está rodando
    if ! docker info > /dev/null 2>&1; then
        error "Docker não está rodando. Por favor, inicie o Docker Desktop."
        exit 1
    fi
    
    # Verificar se gcloud está autenticado
    if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
        error "Nenhuma conta ativa no gcloud. Execute: gcloud auth login"
        exit 1
    fi
    
    # Verificar se terraform está instalado
    if ! command -v terraform &> /dev/null; then
        error "Terraform não está instalado."
        exit 1
    fi
    
    log "✅ Todos os pré-requisitos estão OK"
}

# Função principal de deploy
deploy() {
    local mode=${1:-"full"}
    
    case $mode in
        "build-only")
            log "🔨 Executando apenas build e push das imagens..."
            ./build-and-push.sh
            ;;
        "terraform-only")
            log "🏗️ Executando apenas Terraform apply..."
            terraform plan
            read -p "Confirma a aplicação das mudanças? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                terraform apply -auto-approve
            else
                warn "Deploy cancelado pelo usuário."
                exit 0
            fi
            ;;
        "full")
            log "🚀 Executando deploy completo..."
            
            # 1. Atualizar configurações do Terraform
            log "1/4 Atualizando configurações do Terraform..."
            ./update-terraform-images.sh
            
            # 2. Build e push das imagens
            log "2/4 Executando build e push das imagens..."
            ./build-and-push.sh
            
            # 3. Terraform plan
            log "3/4 Executando terraform plan..."
            terraform plan
            
            # 4. Confirmação e apply
            log "4/4 Pronto para aplicar mudanças..."
            echo ""
            warn "⚠️  As mudanças acima serão aplicadas na infraestrutura."
            read -p "Confirma a aplicação? (y/N): " -n 1 -r
            echo ""
            
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                log "Aplicando mudanças..."
                terraform apply -auto-approve
                
                # Mostrar URLs dos serviços
                log "✅ Deploy concluído com sucesso!"
                echo ""
                log "🌐 URLs dos serviços:"
                gcloud run services list --region=us-central1 --format="table(metadata.name,status.url)"
                
            else
                warn "Deploy cancelado pelo usuário."
                exit 0
            fi
            ;;
        *)
            error "Modo inválido: $mode"
            echo "Modos disponíveis: full, build-only, terraform-only"
            exit 1
            ;;
    esac
}

# Função de ajuda
show_help() {
    echo -e "${BLUE}Death Star Infrastructure Deploy Script${NC}"
    echo ""
    echo "Uso: $0 [MODO]"
    echo ""
    echo "Modos disponíveis:"
    echo "  full           Deploy completo (padrão) - build + terraform"
    echo "  build-only     Apenas build e push das imagens"
    echo "  terraform-only Apenas terraform apply"
    echo "  help           Mostra esta ajuda"
    echo ""
    echo "Exemplos:"
    echo "  $0              # Deploy completo"
    echo "  $0 full         # Deploy completo"
    echo "  $0 build-only   # Apenas build das imagens"
    echo "  $0 terraform-only # Apenas terraform apply"
}

# Parse de argumentos
case ${1:-"full"} in
    "help"|"-h"|"--help")
        show_help
        exit 0
        ;;
    *)
        check_prerequisites
        deploy $1
        ;;
esac

echo ""
echo -e "${GREEN}🎉 Script executado com sucesso!${NC}"