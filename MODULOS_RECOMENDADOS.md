# 🇧🇷 Módulos de Localização Brasileira Recomendados

## 📦 Módulos Core (OCA l10n-brazil)

### Core Base
| Módulo | Versão | Descrição | Dependências |
|--------|---------|------------|---------------|
| **l10n_br** | 17.0 | Base da localização brasileira (CNPJ, CPF, estados) | base |
| **l10n_br_base** | 17.0 | Configurações base para Brasil | l10n_br |
| **l10n_br_address** | 17.0 | Campos de endereço estendidos (CEP, IBGE) | l10n_br |

### Localização por Módulo Odoo

#### Vendas (Sale)
```
l10n_br_sale                    - Localização para módulo de Vendas
  - ICMS, IPI, PIS, COFINS
  - NF-e (Nota Fiscal Eletrônica)
  - Campos fiscais em documentos de venda
  - Integração com Sefaz (webservice NF-e)
  - Redução de base ICMS
  - Substituição tributária
```

#### Compras (Purchase)
```
l10n_br_purchase                - Localização para módulo de Compras
  - Recebimento de NF-e de fornecedores
  - Cálculo de impostos na entrada
  - Retenção de ISS/INSS
  - Conformidade SPED
```

#### Contabilidade (Account)
```
l10n_br_account                 - Localização para módulo de Contabilidade
  - Plano de contas brasileiro
  - Configuração de impostos
  - Retenções (ISS, INSS, IR, CSLL)
  - Cálculo de PIS/COFINS
  - Informações de empresa e contribuinte
  - Campos para SPED
```

#### Estoque (Stock)
```
l10n_br_stock                   - Localização para módulo de Estoque
  - Operações com NFe de entrada
  - Rastreamento de lotes
  - Informações de documento fiscal
```

### Fiscalização e Compliance

```
l10n_br_nfe                     - Nota Fiscal Eletrônica (NF-e)
  - Geração de XML NF-e
  - Comunicação com SEFAZ
  - Cancelamento e subst. de NF
  - Danfe (Documento Auxiliar)

l10n_br_nfse                    - Nota Fiscal de Serviços Eletrônica (NFS-e)
  - Emissão de NFS-e por serviço
  - Integração com ABRASF
  - Reténtion de impostos em serviços

l10n_br_sped                    - Sistema Público de Escrituração Digital (SPED)
  - SPED Contábil (ECD)
  - SPED Fiscal (ECF)
  - SPED Contribuições (EFD)
  - Exportação em formato SPED
  - Validações de conformidade

l10n_br_sintegra               - SINTEGRA (Substitui SPED Fiscal em alguns estados)
  - Geração de arquivo SINTEGRA
  - Para contribuintes do ICMS

l10n_br_cfd                    - Cupom Fiscal Digital (CFD)
  - Para PDV e varejo

l10n_br_ei_gerencial           - Escrituração Fiscal Gerencial (EFG)
  - Obrigatório para alguns estados

l10n_br_folha_de_pagamento     - Folha de Pagamento
  - Cálculo de salário
  - Descontos (INSS, IR, FGTS)
  - Geração de recibos
  - Integração com ESOCIAL
```

---

## 🕒 Sequência Recomendada de Instalação

### Fase 1: Base (OBRIGATÓRIO)
```bash
docker exec -it odoo-app odoo -d odoo_db -i l10n_br --stop-after-init
```

### Fase 2: Core Operacional (Recomendado)
```bash
# Vendas + Compras + Contabilidade
docker exec -it odoo-app odoo -d odoo_db -i l10n_br_sale,l10n_br_purchase,l10n_br_account --stop-after-init
```

### Fase 3: Fiscal (Conforme necessidade)
```bash
# NF-e (se vender para fora da empresa)
docker exec -it odoo-app odoo -d odoo_db -i l10n_br_nfe --stop-after-init

# NFS-e (se prestar serviços)
docker exec -it odoo-app odoo -d odoo_db -i l10n_br_nfse --stop-after-init

# SPED (obrigatório por lei para a maioria)
docker exec -it odoo-app odoo -d odoo_db -i l10n_br_sped --stop-after-init
```

### Fase 4: Outros (Conforme perfil)
```bash
# Folha de pagamento
docker exec -it odoo-app odoo -d odoo_db -i l10n_br_folha_de_pagamento --stop-after-init

# PDV/Varejo
docker exec -it odoo-app odoo -d odoo_db -i l10n_br_cfd --stop-after-init
```

---

## 📊 Community Modules (OCA - Adicionais)

### Ferramentas de Suporte
```
server-tools                   - Ferramentas gerais de servidor
server-ux                      - Melhorias de UX
account-tools                  - Ferramentas contabilidade
account-move-bulk-post         - Postãgem em lote de movimentações
account-invoice-refund         - Devolução de faturas
```

### Logística e Estoque
```
stock-intrastat-br             - Intrastat Brasil
delivery-br                    - Transportadoras brasileiras
stock-picking-batch            - Agrupamento de coletas
stock-move-split-lot           - Divisão de lotes
```

### Relatórios
```
report-br                      - Relatórios especializados para Brasil
report-template                - Templates de relatórios
```

---

## 🌐 Instalação via Interface Web

### Método 1: Instalador Automático

1. **Login**: `admin` / `sua_senha`
2. **Menu**: Apps (ou Aplicativos)
3. **Pesquisa**: Procure "l10n_br" ou "Brazilian"
4. **Filtro**: Todos (ou mostrar desinstalados)
5. **Clique no módulo** que deseja
6. **Botão**: Instalar (em azul)
7. **Aguarde**: Build e ativação

### Método 2: Instalação com Dependências

- O Odoo automatically instala módulos dependências
- Ex: Instalar `l10n_br_nfe` instala `l10n_br` automaticamente

---

## ⌨️ Instalação via Linha de Comando

### Instalar um módulo
```bash
docker exec -it odoo-app odoo -d odoo_db -i l10n_br_nfe --stop-after-init
```

### Instalar móltiplos módulos
```bash
docker exec -it odoo-app odoo -d odoo_db \
  -i l10n_br,l10n_br_sale,l10n_br_purchase,l10n_br_account \
  --stop-after-init
```

### Atualizar módulo
```bash
docker exec -it odoo-app odoo -d odoo_db -u l10n_br --stop-after-init
```

### Desinstalar módulo
```bash
docker exec -it odoo-app odoo -d odoo_db -r l10n_br --stop-after-init
```

---

## 📚 Configuração Após Instalação

### 1. Localização
```
Settings > Localization
- País: Brasil
- Idioma: Portuguese (Brazil)
- Moeda: R$ BRL
- Timezone: America/Sao_Paulo
```

### 2. Empresa
```
Settings > Companies > Sua Empresa
- País: Brasil
- CNPJ: XX.XXX.XXX/XXXX-XX
- Inscrição Estadual (IE): XXXXXX (varia por estado)
- Inscrição Municipal (IM): XXXXXX (se aplicável)
```

### 3. Impostos
```
Accounting > Configuration > Taxes
- Configurar aliquotas de ICMS
- Configurar aliquotas de IPI
- Configurar aliquotas de PIS/COFINS
- Configurar INSS/ISS (se aplicável)
```

### 4. NF-e (se instalado)
```
Sales > Configuration > NF-e
- Certificado Digital (A1)
- Configuração de série de NF-e
- Ambiente (produção vs homologação)
- Dados de contábil
```

---

## 📘 Recursos Adicionais

### Documentação
- [OCA l10n-brazil Wiki](https://github.com/OCA/l10n-brazil/wiki)
- [OCA l10n-brazil Issues](https://github.com/OCA/l10n-brazil/issues)
- [Odoo Docs PT-BR](https://www.odoo.com/documentation/17.0/pt_BR/)

### Comunidade
- [Telegram Odoo Brasil](https://t.me/odoobrasil)
- [Github OCA](https://github.com/OCA)
- [Forum Odoo](https://www.odoo.com/forum)

---

## ✅ Checklist de Setup Completo

- [ ] `l10n_br` instalado
- [ ] `l10n_br_sale` instalado (se vender)
- [ ] `l10n_br_purchase` instalado (se comprar)
- [ ] `l10n_br_account` instalado
- [ ] Localização configurada (PT-BR, Brasil)
- [ ] Empresa configurada com CNPJ
- [ ] Impostos configurados
- [ ] `l10n_br_nfe` instalado (se emitir NF-e)
- [ ] Certificado digital enviado (se NFe)
- [ ] `l10n_br_sped` instalado (se obrigatório)
- [ ] Primeiro teste de emissão feito
- [ ] Backup realizado

---

**Última atualização:** 21 de janeiro de 2026  
**Versão:** 1.0.0
