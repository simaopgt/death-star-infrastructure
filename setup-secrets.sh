#!/bin/bash

# Setup GitHub Secrets for GitOps Workflow
# Este script configura os secrets necessários para o workflow GitOps

set -e

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🔐 Death Star GitOps - Setup Secrets${NC}"
echo "=============================================="

# Verificar se gh CLI está instalado
if ! command -v gh &> /dev/null; then
    echo -e "${RED}GitHub CLI (gh) não está instalado.${NC}"
    echo "Instale com: brew install gh"
    exit 1
fi

# Verificar autenticação
if ! gh auth status &> /dev/null; then
    echo -e "${YELLOW}Fazendo login no GitHub...${NC}"
    gh auth login
fi

# Configurações
PROJECT_ID="death-star-platform-666"
SERVICE_ACCOUNT_EMAIL="terraform-sa@${PROJECT_ID}.iam.gserviceaccount.com"
KEY_FILE="/Users/simaopgt/terraform-sa-key.json"

echo -e "${GREEN}📋 Configurando secrets para os repositórios...${NC}"

# Função para configurar secrets
setup_secrets() {
    local repo=$1
    local secrets=("${@:2}")
    
    echo -e "${YELLOW}Configurando secrets para ${repo}...${NC}"
    
    for secret in "${secrets[@]}"; do
        case $secret in
            "GCP_SA_KEY")
                if [ -f "$KEY_FILE" ]; then
                    gh secret set GCP_SA_KEY --body "$(cat $KEY_FILE)" --repo "$repo"
                    echo "✅ GCP_SA_KEY configurado"
                else
                    echo -e "${RED}❌ Arquivo $KEY_FILE não encontrado${NC}"
                fi
                ;;
            "INFRASTRUCTURE_PAT")
                echo -e "${YELLOW}Para INFRASTRUCTURE_PAT, você precisa:${NC}"
                echo "1. Ir para https://github.com/settings/tokens"
                echo "2. Criar um Personal Access Token com permissões:"
                echo "   - repo (full control)"
                echo "   - workflow"
                echo "3. Executar: gh secret set INFRASTRUCTURE_PAT --body 'seu-token-aqui' --repo '$repo'"
                ;;
        esac
    done
}

# Configurar secrets por repositório
echo ""
echo -e "${GREEN}1. Configurando repositório de infraestrutura...${NC}"
setup_secrets "project-death-star/death-star-infrastructure" "GCP_SA_KEY"

echo ""
echo -e "${GREEN}2. Configurando repositório command-core...${NC}"
setup_secrets "project-death-star/death-star-command-core" "GCP_SA_KEY" "INFRASTRUCTURE_PAT"

echo ""
echo -e "${GREEN}3. Configurando repositório bridge-ui...${NC}"
setup_secrets "project-death-star/death-star-bridge-ui" "GCP_SA_KEY" "INFRASTRUCTURE_PAT"

echo ""
echo -e "${GREEN}✅ Configuração de secrets concluída!${NC}"
echo ""
echo -e "${YELLOW}📝 Próximos passos:${NC}"
echo "1. Configurar INFRASTRUCTURE_PAT manualmente (instruções acima)"
echo "2. Fazer push dos workflows para os repositórios"
echo "3. Testar o workflow fazendo um commit"
echo ""
echo -e "${GREEN}🚀 GitOps workflow está pronto para uso!${NC}"