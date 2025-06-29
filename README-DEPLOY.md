# Death Star Infrastructure - Deploy Automation

Este repositório contém scripts automatizados para build, push e deploy da infraestrutura Death Star no Google Cloud Platform.

## 📋 Pré-requisitos

- **Docker Desktop** rodando
- **gcloud CLI** instalado e autenticado (`gcloud auth login`)
- **Terraform** instalado
- **Acesso ao projeto GCP** `death-star-platform-666`

## 🚀 Scripts Disponíveis

### 1. `deploy.sh` - Script Principal (RECOMENDADO)

Script master que automatiza todo o processo.

```bash
# Deploy completo (build + terraform)
./deploy.sh

# Apenas build e push das imagens
./deploy.sh build-only

# Apenas terraform apply
./deploy.sh terraform-only

# Ajuda
./deploy.sh help
```

### 2. `build-and-push.sh` - Build e Push das Imagens

Faz build das imagens Docker e push para o Google Artifact Registry.

```bash
./build-and-push.sh
```

**O que faz:**
- ✅ Build das imagens `command-core` e `bridge-ui`
- ✅ Push para `us-central1-docker.pkg.dev/death-star-platform-666/ghcr-remote/`
- ✅ Configuração automática da autenticação Docker

### 3. `update-terraform-images.sh` - Atualização do Terraform

Atualiza as configurações do Terraform para usar as imagens customizadas.

```bash
./update-terraform-images.sh
```

**O que faz:**
- ✅ Cria backup do `cloudrun.tf` atual
- ✅ Atualiza configurações para usar imagens do Artifact Registry
- ✅ Adiciona configurações de scaling e variáveis de ambiente

## 🔧 Fluxo de Deploy Completo

### Opção 1: Deploy Automático (Recomendado)

```bash
# 1. Execute o script principal
./deploy.sh

# 2. Confirme quando solicitado
# O script fará tudo automaticamente
```

### Opção 2: Deploy Manual (Passo a Passo)

```bash
# 1. Atualizar configurações do Terraform
./update-terraform-images.sh

# 2. Build e push das imagens
./build-and-push.sh

# 3. Verificar mudanças no Terraform
terraform plan

# 4. Aplicar mudanças
terraform apply
```

## 📦 Imagens Construídas

Após executar o build, as seguintes imagens estarão disponíveis:

- `us-central1-docker.pkg.dev/death-star-platform-666/ghcr-remote/project-death-star/death-star-command-core:latest`
- `us-central1-docker.pkg.dev/death-star-platform-666/ghcr-remote/project-death-star/death-star-bridge-ui:latest`

## 🌐 Serviços Implantados

Após o deploy, os serviços estarão disponíveis em:

- **Command Core**: `https://command-core-967931000097.us-central1.run.app`
- **Bridge UI**: `https://bridge-ui-967931000097.us-central1.run.app`

## 🔍 Verificação do Deploy

```bash
# Listar serviços Cloud Run
gcloud run services list --region=us-central1

# Verificar imagens no Artifact Registry
gcloud artifacts docker images list us-central1-docker.pkg.dev/death-star-platform-666/ghcr-remote --include-tags

# Status do Terraform
terraform show
```

## 🚨 Troubleshooting

### Docker não está rodando
```bash
# Iniciar Docker Desktop manualmente ou:
open -a Docker
```

### Erro de autenticação do gcloud
```bash
gcloud auth login
gcloud auth application-default login
```

### Erro de permissões no Artifact Registry
```bash
gcloud auth configure-docker us-central1-docker.pkg.dev
```

### Erro no build da imagem
- Verificar se os Dockerfiles existem nos repositórios
- Verificar se o Docker tem acesso aos diretórios dos projetos

## 📁 Estrutura dos Arquivos

```
death-star-infrastructure/
├── deploy.sh                    # Script principal
├── build-and-push.sh           # Build e push das imagens
├── update-terraform-images.sh   # Atualização do Terraform
├── cloudrun.tf                 # Configurações do Cloud Run
├── cloudrun.tf.backup          # Backup automático
└── README-DEPLOY.md            # Esta documentação
```

## 🔄 Rollback

Se precisar reverter para as imagens anteriores:

```bash
# 1. Restaurar backup do Terraform
cp cloudrun.tf.backup cloudrun.tf

# 2. Aplicar configuração anterior
terraform apply
```

## 🎯 Próximos Passos

Após o deploy bem-sucedido:

1. ✅ Testar os endpoints dos serviços
2. ✅ Configurar monitoramento e alertas
3. ✅ Configurar CI/CD pipeline
4. ✅ Implementar GitOps com ArgoCD

---

**🎉 Happy Deploying!**