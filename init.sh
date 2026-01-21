#!/bin/bash

set -e

echo "======================================="
echo "Odoo 17 Brasil - Setup de Localização"
echo "======================================="

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Criar diretórios
echo -e "${YELLOW}[*] Criando diretórios em /DATA/AppData/odoo...${NC}"
mkdir -p /DATA/AppData/odoo/{postgres,addons,config,data,logs}

echo -e "${YELLOW}[*] Definindo permissões...${NC}"
chmod -R 755 /DATA/AppData/odoo

# Copiar arquivo .env
if [ ! -f .env ]; then
    echo -e "${YELLOW}[*] Criando arquivo .env a partir de .env.example...${NC}"
    cp .env.example .env
    echo -e "${RED}[!] IMPORTANTE: Edite o arquivo .env com suas configurações!${NC}"
fi

# Verificar se Docker está rodando
echo -e "${YELLOW}[*] Verificando Docker...${NC}"
if ! docker ps > /dev/null 2>&1; then
    echo -e "${RED}[!] Docker não está rodando. Inicie o Docker e tente novamente.${NC}"
    exit 1
fi

echo -e "${GREEN}[+] Docker está ativo${NC}"

# Build da imagem customizada
echo -e "${YELLOW}[*] Buildando imagem Docker customizada...${NC}"
docker build -t odoo:17.0-brasil . --no-cache

echo -e "${GREEN}[+] Build concluído!${NC}"

echo ""
echo -e "${GREEN}======================================="
echo "Setup Concluído com Sucesso!"
echo "========================================${NC}"
echo ""
echo "Próximos passos:"
echo "1. Edite o arquivo .env com suas configurações"
echo "2. Use em Portainer:"
echo "   - Web Editor > Cole o conteúdo de docker-compose.yml"
echo "   - Ou faa deploy com: docker-compose -f docker-compose.yml up -d"
echo ""
echo "Acessar Odoo:"
echo -e "   ${GREEN}http://10.41.10.147:8069${NC}"
echo ""
