# Odoo 17 LTS - Localização Brasileira em Docker/Container

## 📋 Visão Geral

Este repositório contém uma configuração completa de **Odoo 17 LTS** com localização brasileira (l10n_br) rodando em **Docker Containers** com **rede macvlan-dhcp** para IP real na sua infraestrutura.

### Stack Tecnológico

- **Odoo 17.0 LTS** (suporte até 2026)
- **PostgreSQL 15 Alpine** (banco de dados)
- **Docker Compose** (orquestração)
- **macvlan-dhcp** (rede com IP real)
- **Portainer** (gerenciamento de containers)

### Especificações de Localização Brasileira

- ✅ **l10n_br** - Base da localização (CNPJ, CPF, validações)
- ✅ **l10n_br_account** - Contabilidade (Imposto, Retenções)
- ✅ **l10n_br_sale** - Vendas (NF-e, NFe)
- ✅ **l10n_br_purchase** - Compras
- ✅ **l10n_br_stock** - Estoque/Inventário
- ✅ **NF-e integration** (Sefaz)
- ✅ **Sintegra/ICMS**
- ✅ **Impostos IPI, ICMS, PIS, COFINS**

---

## 🏗️ Arquitetura da Rede

```
Sua VM (Portainer)
├── Rede macvlan-dhcp (10.41.10.0/24)
│   ├── Caddy: 10.41.10.128
│   ├── Adminer: 10.41.10.129
│   ├── MariaDB: 10.41.10.131
│   ├── PostgreSQL (Odoo DB): 10.41.10.148 ← NOVO
│   └── Odoo 17: 10.41.10.147 ← NOVO
│
└── /DATA/AppData/odoo/
    ├── postgres/     (dados do banco)
    ├── addons/       (módulos l10n_br)
    ├── config/       (odoo.conf)
    ├── data/         (dados odoo)
    └── logs/         (logs)
```

---

## 📦 Arquivos do Repositório

```
odoo-brasil-docker/
├── docker-compose.yml      # Orquestração de containers (Odoo + PostgreSQL)
├── Dockerfile              # Imagem customizada com l10n_br
├── odoo.conf               # Configuração do Odoo
├── .env.example            # Variáveis de ambiente (template)
├── init.sh                 # Script de inicialização e build
├── install-modules.sh      # Script para instalar módulos l10n_br
├── README.md               # Este arquivo
└── portainer-stack.yml     # Alternativa para deploy via Portainer UI
```

---

## 🚀 Instalação Rápida (via Terminal/SSH)

### 1️⃣ Clonar Repositório

```bash
cd /DATA/AppData
git clone https://github.com/luanscps/odoo-brasil-docker.git odoo
cd odoo
```

### 2️⃣ Configurar Variáveis

```bash
cp .env.example .env
# Edite o arquivo .env com suas configurações
nano .env
```

**Valores importantes no .env:**
```env
DB_PASSWORD=SuaSenhaSegura123!    # Mude para senha forte
ADMIN_PASSWORD=AdminSeguro123!     # Senha do admin Odoo
ODOO_IP=10.41.10.147               # IP da rede macvlan
DB_IP=10.41.10.148                 # IP do banco (PostgreSQL)
```

### 3️⃣ Executar Script de Inicialização

```bash
chmod +x init.sh
./init.sh
```

Este script vai:
- ✅ Criar diretórios em `/DATA/AppData/odoo/`
- ✅ Fazer build da imagem Odoo customizada
- ✅ Preparar arquivo `.env`

### 4️⃣ Iniciar Containers

**Opção A - Via Docker Compose (terminal):**
```bash
docker-compose up -d
```

**Opção B - Via Portainer UI:**
1. Acesse Portainer: `http://10.0.110.132:9001`
2. Environment > Stacks > Add Stack
3. Copie todo conteúdo de `docker-compose.yml`
4. Cole na seção Editor
5. Clique em "Deploy the stack"

### 5️⃣ Instalar Módulos l10n_br

Espere 2-3 minutos para o Odoo inicializar completamente, depois:

```bash
chmod +x install-modules.sh
./install-modules.sh
```

Este script vai:
- ✅ Clonar repositório OCA l10n-brazil
- ✅ Atualizar lista de módulos
- ✅ Exibir guia de instalação

---

## 🌐 Acessar Odoo

### URL de Acesso

- **Dentro da rede (recomendado)**: `http://10.41.10.147:8069`
- **Credenciais padrão**:
  - Usuário: `admin`
  - Senha: `admin` (MUDE APÓS PRIMEIRO LOGIN!)

### Configuração Inicial

1. **Login**: `admin` / `admin`
2. **Ativar Modo Desenvolvedor**:
   - Canto superior direito > Settings (engrenagem)
   - Ativar "Developer mode"

3. **Instalar Módulos l10n_br**:
   - Apps (menu) > Pesquise: `l10n_br`
   - Instale:
     - ✅ Brazilian Localization
     - ✅ Brazilian Localization for Accounting
     - ✅ Brazilian Localization for Sale
     - ✅ Brazilian Localization for Purchase
     - ✅ Brazilian Localization for Stock

4. **Configurar Localização**:
   - Settings > Localization
   - País: `Brasil`
   - Idioma: `Portuguese (Brazil)`
   - Moeda Padrão: `R$ BRL`

---

## 🔧 Gerenciamento de Containers

### Logs

```bash
# Ver logs do Odoo
docker logs -f odoo-app

# Ver logs do PostgreSQL
docker logs -f odoo-db

# Salvar logs para arquivo
docker logs odoo-app > odoo-app.log 2>&1
```

### Executar Comandos no Container

```bash
# Acessar shell do Odoo
docker exec -it odoo-app bash

# Atualizar módulo específico
docker exec -it odoo-app odoo -d odoo_db -u l10n_br --stop-after-init

# Backup do banco
docker exec odoo-db pg_dump -U odoo odoo_db > backup_$(date +%Y%m%d_%H%M%S).sql
```

### Parar/Reiniciar

```bash
# Parar containers
docker-compose down

# Iniciar containers
docker-compose up -d

# Reiniciar containers
docker-compose restart
```

---

## 💾 Backup e Restauração

### Backup do Banco de Dados

```bash
#!/bin/bash
BACKUP_DIR="/DATA/Backups/odoo"
mkdir -p $BACKUP_DIR
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Backup PostgreSQL
docker exec odoo-db pg_dump -U odoo odoo_db | gzip > $BACKUP_DIR/odoo_db_$TIMESTAMP.sql.gz

# Backup de arquivos
tar -czf $BACKUP_DIR/odoo_files_$TIMESTAMP.tar.gz /DATA/AppData/odoo/

echo "Backup concluído: $BACKUP_DIR"
```

### Restaurar Banco

```bash
# Restaurar do backup
gzip -dc backup_20260121_120000.sql.gz | docker exec -i odoo-db psql -U odoo odoo_db
```

---

## 📊 Performance e Tuning

### Ajustar Workers

Em `docker-compose.yml`, altere a variável de comando:

```yaml
command: >
  odoo
  --workers=8        # Aumentar para mais CPU cores
  --worker_timeout=120
  --max_cron_threads=4
  --db-filter=^odoo_db$
```

### Limits de Memória

Em `docker-compose.yml`:

```yaml
odoo:
  deploy:
    resources:
      limits:
        cpus: '4'
        memory: 4G
      reservations:
        cpus: '2'
        memory: 2G
```

---

## 🔐 Segurança

### ⚠️ CRÍTICO - Primeiro Acesso

```bash
# Mude a senha do admin IMEDIATAMENTE
# Settings > Users & Companies > Administrator
# Mude a senha padrão!
```

### Proteção com Reverse Proxy (Caddy)

Já tem Caddy rodando em `10.41.10.128`? Configure um vhost:

```caddyfile
odoo.seu-dominio.com.br {
    reverse_proxy 10.41.10.147:8069 {
        header_up X-Forwarded-For {http.request.remote}
        header_up X-Forwarded-Proto {http.request.proto}
        header_up X-Forwarded-Host {http.request.host}
    }
    
    # Proteção básica
    @admin {
        path /web/setting*
        path /web/database*
    }
    
    ratelimit @admin 5 per 1m
}
```

---

## 📚 Módulos Recomendados Adicionais

### Contabilidade & Fiscal
```
l10n_br_account           - Contabilidade brasileira
l10n_br_nfe              - Nota Fiscal eletrônica
l10n_br_sped             - SPED Contábil/Fiscal
account_invoice_refund   - Devoluções de NF
```

### Vendas & Logística
```
l10n_br_sale             - Localização de Vendas
delivery_br              - Transportadoras
stock_picking_batch      - Agrupamento de coletas
stock_intrastat_br       - Intrastat Brasil
```

### Ferramentas Úteis
```
server-tools             - Ferramentas para servidor
server-ux                - UX customizadas
account_move_bulk_post   - Postagem em lote
base_address_extended    - Endereço estendido
```

Para instalar:
```bash
# Via interface web:
# Apps > Pesquise > Instalar

# Ou via comando:
docker exec -it odoo-app odoo -d odoo_db -i l10n_br_nfe --stop-after-init
```

---

## 🐛 Troubleshooting

### Container não inicia

```bash
# Verificar logs
docker logs odoo-app
docker logs odoo-db

# Verificar recursos
docker stats
```

### Erro de conexão com banco

```bash
# Verificar se PostgreSQL está saudável
docker exec odoo-db pg_isready -U odoo

# Reconectar Odoo ao banco
docker exec -it odoo-app odoo -d odoo_db --stop-after-init
```

### Módulo não aparece na lista

```bash
# Atualizar lista de apps
docker exec -it odoo-app odoo -d odoo_db -u base --stop-after-init

# Ou via interface:
# Settings > Apps > Update App List
```

### Erro de IP macvlan

```bash
# Verificar configuração macvlan
docker network ls
docker network inspect macvlan-dhcp

# Se precisar recriar (CUIDADO!):
docker network rm macvlan-dhcp
docker-compose down
docker-compose up -d
```

---

## 📞 Suporte e Recursos

### Documentação Oficial
- 📖 [Odoo 17 Docs](https://www.odoo.com/documentation/17.0/)
- 🇧🇷 [OCA l10n-brazil](https://github.com/OCA/l10n-brazil)
- 🛠️ [OCA Localization BR Wiki](https://github.com/OCA/l10n-brazil/wiki)

### Comunidade
- 💬 [Odoo Brasil Telegram](https://t.me/odoobrasil)
- 🐍 [OCA GitHub](https://github.com/OCA)
- 📖 [Odoo Brasil Forum](https://www.odoo.com.br)

---

## 📝 Changelog

### v1.0.0 - 2026-01-21
- ✅ Suporte Odoo 17 LTS
- ✅ Localização brasileira completa (l10n_br)
- ✅ Configuração macvlan-dhcp para IP real
- ✅ Docker Compose com PostgreSQL 15
- ✅ Scripts de instalação e backup
- ✅ Documentação completa em PT-BR

---

**Última atualização**: 21 de janeiro de 2026  
**Versão**: 1.0.0  
**Autor**: Luan (luanscps)
