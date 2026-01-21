# 🔫 Comandos Úteis - Referência Rápida

## 🔄 Gerenciar Containers

### Iniciar/Parar
```bash
# Iniciar
docker-compose up -d

# Parar (sem remover)
docker-compose stop

# Reiniciar
docker-compose restart

# Parar e remover
docker-compose down

# Remover volumes também (CUIDADO!)
docker-compose down -v
```

### Verificar Status
```bash
# Ver containers rodando
docker ps

# Ver containers (inclusive parados)
docker ps -a

# Ver status detalhado
docker-compose ps

# Ver recursos em tempo real
docker stats

# Ver recursos de um container
docker stats odoo-app
```

---

## 📐 Logs

### Ver Logs
```bash
# Log do Odoo (tempo real)
docker logs -f odoo-app

# Log do PostgreSQL
docker logs -f odoo-db

# Ültimas 100 linhas
docker logs --tail 100 odoo-app

# Ültimas 2 horas
docker logs --since 2h odoo-app

# Salvar log em arquivo
docker logs odoo-app > odoo-app.log 2>&1

# Ver erro específico
docker logs odoo-app 2>&1 | grep -i error
```

---

## 🗣️ Executar Comandos no Container

### Acessar Shell
```bash
# Bash do Odoo
docker exec -it odoo-app bash

# Bash do PostgreSQL
docker exec -it odoo-db bash

# Shell PostgreSQL (psql)
docker exec -it odoo-db psql -U odoo odoo_db
```

### Comandos Odoo
```bash
# Atualizar lista de módulos
docker exec -it odoo-app odoo -d odoo_db -u base --stop-after-init

# Instalar módulo
docker exec -it odoo-app odoo -d odoo_db -i l10n_br_nfe --stop-after-init

# Desinstalar módulo
docker exec -it odoo-app odoo -d odoo_db -r l10n_br_nfe --stop-after-init

# Atualizar módulo
docker exec -it odoo-app odoo -d odoo_db -u l10n_br --stop-after-init

# Modo safe (sem atualizar)
docker exec -it odoo-app odoo -d odoo_db --safe-mode
```

### Banco de Dados
```bash
# Ver bancos disponíveis
docker exec -it odoo-db psql -U odoo -l

# Verificar saúde do banco
docker exec -it odoo-db pg_isready -U odoo

# Ver conexões ativas
docker exec -it odoo-db psql -U odoo odoo_db -c "SELECT * FROM pg_stat_activity;"

# Vacuum (limpeza)
docker exec -it odoo-db psql -U odoo odoo_db -c "VACUUM ANALYZE;"

# Tamanho do banco
docker exec -it odoo-db psql -U odoo odoo_db -c "SELECT pg_size_pretty(pg_database_size('odoo_db'));"
```

---

## 💾 Backup e Restauração

### Backup Banco de Dados
```bash
# Backup completo
docker exec odoo-db pg_dump -U odoo odoo_db > backup_$(date +%Y%m%d_%H%M%S).sql

# Backup comprimido
docker exec odoo-db pg_dump -U odoo odoo_db | gzip > backup_$(date +%Y%m%d_%H%M%S).sql.gz

# Backup customizado (sem verbose)
docker exec odoo-db pg_dump -U odoo -F c odoo_db > backup_$(date +%Y%m%d_%H%M%S).dump
```

### Restaurar Banco
```bash
# Restaurar de SQL
gzip -dc backup_20260121_120000.sql.gz | docker exec -i odoo-db psql -U odoo odoo_db

# Restaurar de DUMP
docker exec -i odoo-db pg_restore -U odoo -d odoo_db < backup_20260121_120000.dump

# Restaurar e substituir (dropa banco antes)
docker exec -i odoo-db dropdb -U odoo odoo_db
docker exec -i odoo-db createdb -U odoo odoo_db
gzip -dc backup.sql.gz | docker exec -i odoo-db psql -U odoo odoo_db
```

### Backup de Arquivos
```bash
# Backup do diretório de dados
tar -czf odoo_files_$(date +%Y%m%d_%H%M%S).tar.gz /DATA/AppData/odoo/

# Backup de módulos customizados
tar -czf odoo_addons_$(date +%Y%m%d_%H%M%S).tar.gz /DATA/AppData/odoo/addons/

# Backup completo (banco + arquivos)
BACKUP_DIR="/DATA/Backups/odoo"
mkdir -p $BACKUP_DIR
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

docker exec odoo-db pg_dump -U odoo odoo_db | gzip > $BACKUP_DIR/db_$TIMESTAMP.sql.gz
tar -czf $BACKUP_DIR/files_$TIMESTAMP.tar.gz /DATA/AppData/odoo/

echo "Backup completo criado: $BACKUP_DIR"
```

### Restaurar Backup Completo
```bash
#!/bin/bash

# Parâmetros
BACKUP_FILE="$1"
if [ -z "$BACKUP_FILE" ]; then
    echo "Uso: $0 backup_20260121_120000.sql.gz"
    exit 1
fi

# Parar container
docker-compose stop odoo-app

# Dropar banco antigo
docker exec -i odoo-db dropdb -U odoo odoo_db || true

# Criar banco novo
docker exec -i odoo-db createdb -U odoo odoo_db

# Restaurar dados
gzip -dc "$BACKUP_FILE" | docker exec -i odoo-db psql -U odoo odoo_db

# Iniciar container
docker-compose up -d odoo-app

echo "[+] Restauração concluída"
echo "[*] Aguarde 1-2 minutos para Odoo inicializar"
```

---

## 📄 Gerenciar Volumes

### Ver Volumes
```bash
# Listar volumes
docker volume ls

# Detalhes de um volume
docker volume inspect odoo-brasil-docker_postgres_data

# Usar um volume em outro container
docker run -v odoo-brasil-docker_postgres_data:/mnt/data -it alpine sh
```

### Limpar Volumes
```bash
# Remover volumes não utilizados
docker volume prune

# Remover um volume específico (CUIDADO!)
docker volume rm odoo-brasil-docker_postgres_data
```

---

## 🌦️ Monitoramento

### Performance
```bash
# CPU e memória em tempo real
docker stats --no-stream

# Latencia de rede
docker exec odoo-app ping 10.41.10.148

# Velocidade do disco
docker exec odoo-db dd if=/dev/zero of=/tmp/test bs=1M count=100
```

### Healthcheck
```bash
# Verificar saúde do Odoo
curl -s http://10.41.10.147:8069/web/health

# Resposta esperada: OK (HTTP 200)

# De dentro do container
docker exec odoo-app curl -s http://localhost:8069/web/health
```

### Ver Eventos
```bash
# Últimos eventos dos containers
docker events --since 1h --filter container=odoo-app

# Apenas eventos de erro
docker events --filter type=container --filter status=die
```

---

## 🛠️ Manutenção

### Limpeza
```bash
# Remover images não utilizadas
docker image prune -a

# Remover containers parados
docker container prune

# Remover TUDO não utilizado
docker system prune -a --volumes

# Ver uso de disco
docker system df
```

### Atualizar Imagens
```bash
# Pull da última versão
docker pull odoo:17.0
docker pull postgres:15-alpine

# Rebuild da imagem customizada
docker build -t odoo:17.0-brasil . --no-cache

# Recriar containers com nova imagem
docker-compose down
docker-compose up -d
```

### Copiar Arquivos
```bash
# Para dentro do container
docker cp meu_arquivo.py odoo-app:/mnt/extra-addons/

# Para fora do container
docker cp odoo-app:/var/lib/odoo/dados.backup ~/backup/

# Entre containers
docker cp odoo-app:/mnt/extra-addons odoo-db:/tmp/
```

---

## 📄 Scripts Automatizados

### Backup Diário
```bash
#!/bin/bash
# cron: 0 2 * * * /home/user/backup_odoo_daily.sh

BACKUP_DIR="/DATA/Backups/odoo"
RETENTION_DAYS=30
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# Backup
echo "[$(date)] Iniciando backup..."
docker exec odoo-db pg_dump -U odoo odoo_db | gzip > $BACKUP_DIR/odoo_db_$TIMESTAMP.sql.gz

# Limpeza de backups antigos
find $BACKUP_DIR -name "odoo_db_*.sql.gz" -mtime +$RETENTION_DAYS -delete

echo "[$(date)] Backup concluído: $BACKUP_DIR/odoo_db_$TIMESTAMP.sql.gz"
```

### Monitoramento
```bash
#!/bin/bash
# Verificar saúde dos containers

echo "=== Docker Compose Status ==="
docker-compose ps

echo ""
echo "=== Resource Usage ==="
docker stats --no-stream odoo-app odoo-db

echo ""
echo "=== Disk Usage ==="
df -h /DATA/AppData/odoo/

echo ""
echo "=== Container Health ==="
curl -s http://10.41.10.147:8069/web/health && echo " [OK]" || echo " [ERRO]"
```

### Atualizar Módulos
```bash
#!/bin/bash
# Atualizar todos os módulos instalados

echo "[*] Parando Odoo..."
docker-compose stop odoo-app

echo "[*] Atualizando módulos..."
docker exec -it odoo-app odoo -d odoo_db -u all --stop-after-init

echo "[*] Iniciando Odoo..."
docker-compose up -d odoo-app

echo "[+] Atualização concluída"
```

---

## 🔣 Troubleshooting Rápido

### Container não inicia
```bash
# Ver erro completo
docker logs odoo-app

# Verificar configuração
cat docker-compose.yml | grep -A 20 "odoo:"

# Validar YAML
python -m yaml docker-compose.yml
```

### Banco não conecta
```bash
# Ping ao banco
docker exec odoo-app ping 10.41.10.148

# Verificar saúde
docker exec odoo-db pg_isready -U odoo

# Ver logs
docker logs odoo-db | tail -50
```

### Odoo lento
```bash
# Ver recursos
docker stats odoo-app

# Ver queries lentas (banco)
docker exec odoo-db psql -U odoo odoo_db -c "SELECT * FROM pg_stat_statements ORDER BY mean_time DESC LIMIT 10;"

# Aumentar workers em docker-compose.yml
# workers=4 -> workers=8
```

### Erro de permissão
```bash
# Corrigir permissões
sudo chmod -R 755 /DATA/AppData/odoo/
sudo chown -R $USER:$USER /DATA/AppData/odoo/

# No container
docker exec odoo-app chown -R odoo:odoo /mnt/extra-addons /var/lib/odoo
```

---

## 📘 Referências

- [Docker Docs](https://docs.docker.com/)
- [Docker Compose Docs](https://docs.docker.com/compose/)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [Odoo Administration](https://www.odoo.com/documentation/17.0/pt_BR/administration.html)

---

**Última atualização:** 21 de janeiro de 2026
