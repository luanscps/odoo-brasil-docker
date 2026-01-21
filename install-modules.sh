#!/bin/bash

set -e

echo "======================================="
echo "Instalador de Módulos l10n_BR"
echo "======================================="
echo ""

MODULES_DIR="/DATA/AppData/odoo/addons"
ODOO_CONTAINER="odoo-app"

echo "[*] Diretório de módulos: $MODULES_DIR"

# Verificar se o container está rodando
if ! docker ps | grep -q $ODOO_CONTAINER; then
    echo "[!] Container $ODOO_CONTAINER não está rodando!"
    echo "    Inicie com: docker-compose up -d"
    exit 1
fi

echo "[+] Container Odoo encontrado"
echo ""

echo "Módulos de Localização Brasileira disponíveis:"
echo ""
echo "CORE MODULES (ODbr - Oficial Odoo Brasil):"
echo "  1. l10n_br            - Base da localização brasileira"
echo "  2. l10n_br_purchase   - Localização para Compras"
echo "  3. l10n_br_sale       - Localização para Vendas"
echo "  4. l10n_br_account    - Localização para Contabilidade"
echo "  5. l10n_br_stock      - Localização para Estoque"
echo ""
echo "COMMUNITY MODULES (OCA - Odoo Community Association):"
echo "  6. account-invoice-refund - Devolução de Faturas"
echo "  7. server-tools           - Ferramentas de Servidor"
echo "  8. server-ux              - UX Customizadas"
echo ""
echo "Copiando repositório OCA (l10n_br)..."
echo ""

if [ -d "$MODULES_DIR/l10n-brazil" ]; then
    echo "[!] Repositório já existe. Atualizando..."
    cd $MODULES_DIR/l10n-brazil
    git pull origin 17.0
else
    echo "[*] Clonando repositório OCA (l10n-brazil)..."
    cd $MODULES_DIR
    git clone --depth 1 --branch 17.0 https://github.com/OCA/l10n-brazil.git
    echo "[+] Clonado com sucesso!"
fi

echo ""
echo "[*] Instalando/Atualizando lista de módulos no Odoo..."
docker exec $ODOO_CONTAINER odoo -c /etc/odoo/odoo.conf -d odoo_db --stop-after-init -u base

echo ""
echo "======================================="
echo "[+] Módulos instalados com sucesso!"
echo "======================================="
echo ""
echo "Próximos passos:"
echo "1. Acesse: http://10.41.10.147:8069"
echo "2. Login com usuário: admin"
echo "3. Vá para: Apps > Pesquise por 'l10n'"
echo "4. Instale os módulos necessários:"
echo "   - Brazilian Localization (l10n_br)"
echo "   - Brazilian Localization for Purchase (l10n_br_purchase)"
echo "   - Brazilian Localization for Sales (l10n_br_sale)"
echo "   - Brazilian Localization for Accounting (l10n_br_account)"
echo "   - Brazilian Localization for Inventory (l10n_br_stock)"
echo ""
echo "5. Configure em: Settings > Localization"
echo "   - País: Brasil"
echo "   - Idioma: Portuguese (Brazil)"
echo "   - Formato: pt_BR"
echo ""
echo "[*] Suporte: https://github.com/OCA/l10n-brazil/wiki"
echo ""
