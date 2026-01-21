# Odoo 17 com Localização Brasileira (Docker)

## Arquitetura

- **Odoo 17.0** (imagem oficial Docker Hub)
- **PostgreSQL 15** (Alpine para performance)
- **Macvlan Network** com IPs estáticos
- **Volumes persistentes** para dados

## Setup Inicial

### 1. Preparar diretórios na VM

```bash
cd /DATA/AppData/odoo

# Criar estrutura de pastas
mkdir -p postgres data addons
chmod 777 addons  # Permissão para volume

# Verificar
ls -la /DATA/AppData/odoo/
```

### 2. Clonar repositório

```bash
cd /DATA/AppData/odoo
git clone https://github.com/luanscps/odoo-brasil-docker.git .
git checkout main
```

### 3. Primeira execução (IMPORTANTE: sem -d)

```bash
# Parar containers anteriores
docker-compose down -v
rm -rf postgres/* data/*

# Executar SEM background (ver logs em tempo real)
docker-compose up
```

**Aguarde até ver:**
```
odoo_1  | 2026-01-21 13:00:00,000 1 INFO ? odoo.service: Started HTTP service on http://0.0.0.0:8069
```

### 4. Criar banco de dados

Em outra aba do terminal:

```bash
# Acessar Odoo
# http://10.41.10.149:8069

# Fazer setup wizard:
# Email: admin@example.com
# Senha: admin123
# DB Name: odoo_br
# País: Brasil
# Língua: Português (Brasil)
```

### 5. Instalar localização brasileira

Após criar DB:

1. **Ativar Modo Desenvolvedor:**
   - Ir para: **Settings > Activate the developer mode**

2. **Atualizar lista de apps:**
   - Menu superior: **Apps > Update Apps List**
   - Esperar sincronização

3. **Instalar módulos brasileiros:**
   - **Apps > Pesquisar por "l10n_br"**
   - Instalar:
     - `l10n_br` (Base)
     - `l10n_br_account` (Contabilidade)
     - `l10n_br_hr` (RH - opcional)
     - `l10n_br_purchase` (Compras - opcional)

4. **Configurar localização:**
   - **Settings > General Settings**
   - Country: **Brazil**
   - Lang: **Portuguese (Brazil)**
   - Salvar

### 6. Rodar em daemon

Após confirmar que está funcionando:

```bash
# Parar (Ctrl+C no terminal)
# Depois rodar em background
docker-compose up -d

# Ver logs
docker logs -f odoo-app
```

## Addons Customizados

Para adicionar seus próprios módulos:

```bash
# 1. Criar pasta do módulo
mkdir -p /DATA/AppData/odoo/addons/meu_modulo

# 2. Criar estrutura mínima
cd /DATA/AppData/odoo/addons/meu_modulo
touch __init__.py
touch __manifest__.py

# 3. Editar __manifest__.py
cat > __manifest__.py << 'EOF'
{
    'name': 'Meu Módulo',
    'version': '17.0.1.0.0',
    'category': 'Uncategorized',
    'author': 'Seu Nome',
    'installable': True,
    'application': False,
    'depends': ['base'],
}
EOF

# 4. Reiniciar Odoo
docker-compose restart odoo

# 5. Atualizar lista de apps e instalar
```

## Troubleshooting

### Erro: "path '/mnt/extra-addons' is not a valid addons directory"

**Solução:**
- Não use Dockerfile customizado
- Use imagem oficial `odoo:17.0`
- Não passe `--addons-path` via CLI
- Verifique permissões: `chmod 777 /DATA/AppData/odoo/addons`

### Banco de dados não conecta

```bash
# Verificar saúde do PostgreSQL
docker-compose ps

# Ver logs do DB
docker logs odoo-db

# Reiniciar tudo
docker-compose down
rm -rf postgres/*
docker-compose up
```

### Permissão negada em /mnt/extra-addons

```bash
# Na VM
chown -R 999:999 /DATA/AppData/odoo/addons  # 999 é o UID do usuário odoo
chmod 755 /DATA/AppData/odoo/addons

# Ou simplesmente
chmod 777 /DATA/AppData/odoo/addons
```

## Links Útel

- [Odoo Oficial](https://www.odoo.com)
- [Docker Hub - Odoo](https://hub.docker.com/_/odoo)
- [OCA l10n-brazil](https://github.com/OCA/l10n-brazil)
- [Odoo 17 Docs](https://www.odoo.com/documentation/17.0/)

## Suporte

Para dúvidas sobre localização brasileira:
- Grupo OCA: https://github.com/OCA/l10n-brazil
- Issues: Abrir no repositório
