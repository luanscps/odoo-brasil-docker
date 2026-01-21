# 🚀 Quick Start - Setup em 5 minutos

## 1️⃣ Clone o Repositório

```bash
cd /DATA/AppData
git clone https://github.com/luanscps/odoo-brasil-docker.git odoo
cd odoo
```

## 2️⃣ Copie e Configure .env

```bash
cp .env.example .env
cat .env  # Revisar padrões
```

### Se precisar customizar:
```bash
nano .env
# Mude: DB_PASSWORD=SuaSenhaForte123!
# CTRL+O > ENTER para salvar
# CTRL+X para sair
```

## 3️⃣ Execute o Setup

```bash
chmod +x init.sh
./init.sh
```

**Esperado:**
```
[+] Diretórios criados
[+] Build concluído!
```

## 4️⃣ Inicie os Containers

### Opção A: Terminal
```bash
docker-compose up -d

# Aguarde 2-3 minutos
# Verificar:
docker ps | grep odoo
```

### Opção B: Portainer
1. `http://10.0.110.132:9001`
2. Stacks > Add Stack
3. Copie `docker-compose.yml` para Editor
4. Deploy the stack

## 5️⃣ Instale Módulos l10n_br

```bash
chmod +x install-modules.sh
./install-modules.sh
```

---

## 🜐 Acessar

```
URL: http://10.41.10.147:8069
User: admin
Pass: admin (MUDE!)
```

---

## ⚠️ Primeira Coisa: MUDAR SENHA

1. Login com `admin` / `admin`
2. Canto superior direito > Seu nome > My Profile
3. Clique "Change Password"
4. Configure senha forte
5. Salve

---

## 🔧 Troubleshooting Rápido

### Container não inicia?
```bash
# Ver erro
docker logs -f odoo-app

# Aguardar healthcheck
docker ps
# Status deve passar de "starting..." para "Up"
```

### Erro de rede macvlan?
```bash
# Verificar rede
docker network inspect macvlan-dhcp

# Ver IPs dos containers
docker inspect odoo-app | grep -i ipv4
```

### Banco não conecta?
```bash
# Testar conexão
docker exec odoo-db pg_isready -U odoo

# Se falhar, reinicie
docker-compose restart postgres
```

---

## 📚 Próximos Passos

1. ✅ Configurar localização (PT-BR, Brasil, BRL)
2. ✅ Criar empresa com dados fiscais
3. ✅ Instalar módulos adicionais
4. ✅ Fazer backup inicial
5. ✅ Configurar reverse proxy (Caddy)

---

## 📖 Referências

- Docs completo: [README.md](README.md)
- OCA l10n-brazil: https://github.com/OCA/l10n-brazil
- Odoo 17 Docs: https://www.odoo.com/documentation/17.0/

---

**Deu problema?** Verifique [README.md](README.md#-troubleshooting) para soluções detalhadas.
