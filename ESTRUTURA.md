# 📋 Estrutura do Repositório

## 📦 Arquivos Principais

```
odoo-brasil-docker/
├── 📖 README.md                   # Documentação completa (LEIA PRIMEIRO!)
├── 🚀 QUICK_START.md              # Setup em 5 minutos
├── 🇧🇷 MODULOS_RECOMENDADOS.md     # Guia de módulos l10n_br
├── 🔫 COMANDOS_UTEIS.md           # Referência de comandos Docker
├── 📋 ESTRUTURA.md                # Este arquivo
├──
├── 🐨 docker-compose.yml           # Orquestração principal
├── 🐨 portainer-stack.yml          # Alternativa para Portainer
├── 🐨 Dockerfile                   # Imagem customizada Odoo
├── 🐨 odoo.conf                    # Configuração Odoo
├──
├── 🕚 .env.example               # Template de variáveis (crie .env daqui)
├── 🕚 .gitignore                 # Ignore para Git
├──
├── 📋 init.sh                    # Script de setup inicial
├── 📋 install-modules.sh         # Script de instalação de módulos
├──
└── 📐 LICENSE                    # MIT License
```

---

## 📖 Guias de Documentação

### 1. **README.md** 📐 (OBRIGATÓRIO - LEIA PRIMEIRO!)
   - 📋 **Visão Geral**: Sobre o projeto
   - 🏗️ **Arquitetura de Rede**: Como está tudo conectado
   - 🚀 **Instalação Rápida**: Passo a passo completo
   - 🌐 **Acessar Odoo**: URL e credenciais
   - 🔧 **Gerenciamento**: Como gerenciar containers
   - 💾 **Backup/Restauração**: Proteja seus dados
   - 📚 **Módulos Recomendados**: Quais instalar
   - 🐛 **Troubleshooting**: Solução de problemas

### 2. **QUICK_START.md** 🚀 (5 MINUTOS)
   - Para quem quer começar logo!
   - Setup express em 5 passos
   - Ideal para testes rápidos

### 3. **MODULOS_RECOMENDADOS.md** 🇧🇷 (LOCALIZAÇÃO BRASILEIRA)
   - Tabela com todos os módulos l10n_br
   - Descrição de cada módulo
   - Sequência de instalação recomendada
   - Como instalar via UI e CLI
   - Configuração após instalação

### 4. **COMANDOS_UTEIS.md** 🔫 (REFERÈNCIA)
   - Todos os comandos Docker úteis
   - Backup e restauração
   - Monitoramento e performance
   - Scripts automatizados
   - Troubleshooting rápido

### 5. **ESTRUTURA.md** 📋 (ESTE ARQUIVO)
   - Guia de estrutura do repositório
   - Explica o propósito de cada arquivo

---

## 🐨 Arquivos de Configuração

### **docker-compose.yml** 🋱️
```yaml
Serviços:
  ✅ postgres:15-alpine    → Banco de dados
  ✅ odoo:17.0             → Aplicativo principal

Configuração:
  ✅ IPs fixos via macvlan
  ✅ Volumes persistentes
  ✅ Healthchecks
  ✅ Restart policy

Arquivos de Suporte:
  - odoo.conf (configuração Odoo)
  - .env (variáveis sensíveis)
```

### **Dockerfile** 🋳️
```dockerfile
Base: odoo:17.0

Adeções:
  ✅ Dependências do sistema (wkhtmltopdf, etc)
  ✅ Pacotes Python (pycpf, phonenumbers, etc)
  ✅ Configuração de diretórios
  ✅ Permissões de usuário
```

### **odoo.conf** 📄
```ini
Configuracões:
  ✅ Banco de dados (PostgreSQL)
  ✅ Localização (PT-BR, Brasil)
  ✅ Performance (workers, timeout)
  ✅ Segurança (cookies, CORS)
  ✅ Email (SMTP)
```

### **.env.example** 🔗
```env
Variáveis Template:
  ✅ DB_PASSWORD     → Senha do banco (MUDE!)
  ✅ ADMIN_PASSWORD  → Senha do admin (MUDE!)
  ✅ Network config  → IPs e subnets
  ✅ Localização    → PT-BR, Brasil, BRL
```

---

## 📋 Scripts Automáticos

### **init.sh** 🚀
```bash
O que faz:
  1. Cria estrutura de diretórios em /DATA/AppData/odoo/
  2. Faz build da imagem Docker customizada
  3. Valida instalação do Docker
  4. Cria .env a partir de .env.example

Executar:
  $ chmod +x init.sh
  $ ./init.sh
```

### **install-modules.sh** 🇧🇷
```bash
O que faz:
  1. Clona repositório OCA l10n-brazil
  2. Atualiza lista de módulos no Odoo
  3. Exibe guia de instalação

Executar:
  $ chmod +x install-modules.sh
  $ ./install-modules.sh
```

---

## 📋 Fluxo de Uso Recomendado

```
1. 👀 Ler este arquivo (ESTRUTURA.md)
   ↓
2. 📐 Ler README.md completo
   ↓
3. 🚀 Executar QUICK_START.md para setup inicial
   ↓
4. 🐨 Usar docker-compose.yml para iniciar
   ↓
5. 🇧🇷 Consultar MODULOS_RECOMENDADOS.md para l10n_br
   ↓
6. 🔫 Usar COMANDOS_UTEIS.md para administração
   ↓
7. 💋 Manutencão contínua (backup, atualizações)
```

---

## 📄 Estrutura de Diretórios em /DATA

```
/DATA/AppData/odoo/
├── postgres/          ← Dados do PostgreSQL (volume)
├── addons/            ← Módulos l10n_br e customizados
├── config/            ← odoo.conf e configurações
├── data/              ← Dados do Odoo (filestore)
├── logs/              ← Logs de execução
└── .env               ← Variáveis de ambiente (criar de .env.example)

/DATA/Backups/odoo/             ← Backups (criar manualmente)
├── odoo_db_20260121.sql.gz
├── odoo_files_20260121.tar.gz
└── ...
```

---

## 📈 Versão e Compatibilidade

| Componente | Versão | Status | Suporte |
|-----------|--------|--------|----------|
| Odoo | 17.0 LTS | ✅ Ativo | Até 2026 |
| PostgreSQL | 15 Alpine | ✅ Estável | LTS |
| Docker | 20.10+ | ✅ Compatível | Docker CE |
| l10n_br (OCA) | 17.0 | ✅ Ativo | Comunidade |
| Python | 3.10 | ✅ Suportado | 3.8+ |

---

## 📝 Changelog

### v1.0.0 - 21/01/2026
- ✅ Setup inicial completo
- ✅ Odoo 17 LTS + PostgreSQL 15
- ✅ Localização brasileira (l10n_br)
- ✅ Rede macvlan-dhcp configurada
- ✅ Documentação em PT-BR
- ✅ Scripts automáticos

---

## 📞 Suporte e Contribuição

### Encontrou um problema?
1. Verifique [README.md](README.md#-troubleshooting)
2. Verifique [COMANDOS_UTEIS.md](COMANDOS_UTEIS.md)
3. Procure em [Issues do GitHub](https://github.com/luanscps/odoo-brasil-docker/issues)
4. Abra uma nova issue com detalhes

### Quer contribuir?
1. Fork do repositório
2. Crie uma branch (`git checkout -b feature/sua-feature`)
3. Commit suas mudanças (`git commit -am 'Add nova feature'`)
4. Push para a branch (`git push origin feature/sua-feature`)
5. Abra um Pull Request

---

## 📁 Referências Rápidas

**Seu Repositório**: [github.com/luanscps/odoo-brasil-docker](https://github.com/luanscps/odoo-brasil-docker)

**Acessar Odoo**: [http://10.41.10.147:8069](http://10.41.10.147:8069)

**Acessar Portainer**: [http://10.0.110.132:9001](http://10.0.110.132:9001)

**OCA l10n-brazil**: [https://github.com/OCA/l10n-brazil](https://github.com/OCA/l10n-brazil)

**Odoo Docs**: [https://www.odoo.com/documentation/17.0/](https://www.odoo.com/documentation/17.0/)

---

**Última atualização**: 21 de janeiro de 2026
