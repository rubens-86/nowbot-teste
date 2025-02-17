#!/bin/bash

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Iniciando criação do Manual Técnico NowBot...${NC}"

# Criar diretório para documentação
mkdir -p nowbot-docs
cd nowbot-docs

echo -e "${GREEN}Instalando dependências...${NC}"
sudo apt-get update
sudo apt-get install -y \
    pandoc \
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-extra-utils \
    texlive-latex-extra \
    texlive-lang-portuguese

echo -e "${GREEN}Configurando template...${NC}"
wget https://raw.githubusercontent.com/Wandmalfarbe/pandoc-latex-template/master/eisvogel.tex
mkdir -p ~/.pandoc/templates/
mv eisvogel.tex ~/.pandoc/templates/eisvogel.latex

echo -e "${GREEN}Gerando arquivo Markdown...${NC}"
cat > manual.md << 'EOL'
---
title: "Manual Técnico NowBot v6.0.0"
author: [DBranco Moda]
date: "2024"
subject: "Documentação Técnica"
keywords: [NowBot, WhatsApp, Atendimento]
subtitle: "Sistema de Atendimento Multicanal"
lang: "pt-BR"
titlepage: true
titlepage-color: "025A9D"
titlepage-text-color: "FFFFFF"
titlepage-rule-color: "FFFFFF"
titlepage-rule-height: 2
book: true
toc: true
toc-own-page: true
numbersections: true
colorlinks: true
linkcolor: "025A9D"
urlcolor: "025A9D"
---

# Manual Técnico NowBot v6.0.0

## 1. Visão Geral do Sistema

### 1.1 Arquitetura
O NowBot é um sistema de atendimento multicanal construído com arquitetura moderna e escalável, utilizando as seguintes tecnologias principais:

- Frontend: React.js
- Backend: Node.js
- Banco de Dados: PostgreSQL
- Cache: Redis
- Proxy Reverso: Nginx
- Gerenciamento de Processos: PM2
- SSL: Certbot/Let's Encrypt

### 1.2 Componentes Principais

```mermaid
graph TB
    subgraph Infraestrutura
        A[Load Balancer] --> B[Nginx]
        B --> C[Frontend - React]
        B --> D[Backend - Node.js]
        D --> E[PostgreSQL]
        D --> F[Redis]
        D --> G[WhatsApp API]
    end

    subgraph Monitoramento
        H[PM2] --> C
        H --> D
        I[Logs] --> H
    end

    subgraph Segurança
        J[Certbot/SSL] --> B
        K[Firewall] --> B
    end

    subgraph Backup
        L[Backup Diário] --> E
        L --> M[Arquivos de Mídia]
    end
```

### 1.3 Fluxo de Atendimento

```mermaid
sequenceDiagram
    participant C as Cliente
    participant W as WhatsApp
    participant B as Backend
    participant A as Atendente
    participant R as Redis
    participant P as PostgreSQL

    C->>W: Envia mensagem
    W->>B: Webhook
    B->>R: Verifica cache
    B->>P: Salva mensagem
    B->>A: Notifica atendente
    A->>B: Responde
    B->>W: Envia resposta
    W->>C: Recebe resposta
```

## 2. Requisitos do Sistema

### 2.1 Hardware Recomendado
- CPU: 4 cores ou superior
- RAM: 8GB ou superior
- Armazenamento: 50GB SSD
- Rede: 100Mbps

### 2.2 Software Necessário
- Ubuntu 20.04 LTS ou superior
- Node.js 20.x
- PostgreSQL 12+
- Redis 6+
- Nginx
- Docker e Docker Compose
- PM2 (global)

## 3. Processo de Instalação

### 3.1 Preparação do Ambiente

```bash
# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar dependências básicas
sudo apt install -y git curl wget nano software-properties-common

# Instalar Node.js 20.x
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Instalar Docker
curl -fsSL https://get.docker.com | sudo bash
sudo usermod -aG docker $USER

# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Instalar PM2
npm install -g pm2
```

### 3.2 Configuração do Banco de Dados

#### 3.2.1 PostgreSQL
```bash
# Instalar PostgreSQL
sudo apt install -y postgresql postgresql-contrib

# Criar usuário e banco de dados
sudo -u postgres psql -c "CREATE DATABASE nowbot;"
sudo -u postgres psql -c "CREATE USER nowbot WITH ENCRYPTED PASSWORD 'Dbranco20!';"
sudo -u postgres psql -c "ALTER USER nowbot WITH SUPERUSER;"
```

#### 3.2.2 Redis
```bash
# Iniciar Redis via Docker
docker run --name redis-nowbot \
    -p 6379:6379 \
    --restart always \
    -d redis \
    redis-server --requirepass Dbranco20!
```

### 3.3 Configuração do Backend

```bash
cd /home/deploy/nowbot-teste/backend

# Configurar variáveis de ambiente
cat > .env << EOF
NODE_ENV=production
BACKEND_URL=https://api.nowbot.online
FRONTEND_URL=https://app.nowbot.online
PORT=8080

DB_DIALECT=postgres
DB_HOST=localhost
DB_USER=nowbot
DB_PASS=Dbranco20!
DB_NAME=nowbot

REDIS_URI=redis://:Dbranco20!@127.0.0.1:6379

JWT_SECRET=$(openssl rand -base64 32)
JWT_REFRESH_SECRET=$(openssl rand -base64 32)
EOF

# Instalar dependências e construir
npm install
npm run build

# Executar migrações
npx sequelize db:migrate
npx sequelize db:seed:all
```

### 3.4 Configuração do Frontend

```bash
cd /home/deploy/nowbot-teste/frontend

# Configurar variáveis de ambiente
cat > .env << EOF
REACT_APP_BACKEND_URL=https://api.nowbot.online
REACT_APP_HOURS_CLOSE_TICKETS_AUTO=24
EOF

# Instalar dependências e construir
npm install
npm run build
```

### 3.5 Configuração do Nginx

```nginx
# /etc/nginx/sites-available/nowbot

server {
    listen 80;
    listen [::]:80;
    server_name app.nowbot.online api.nowbot.online;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name app.nowbot.online;

    ssl_certificate /etc/letsencrypt/live/api.nowbot.online/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.nowbot.online/privkey.pem;
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:50m;
    ssl_session_tickets off;

    # Configurações modernas de SSL
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
    ssl_prefer_server_ciphers off;

    # HSTS
    add_header Strict-Transport-Security "max-age=63072000" always;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name api.nowbot.online;

    ssl_certificate /etc/letsencrypt/live/api.nowbot.online/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.nowbot.online/privkey.pem;

    location / {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### 3.6 Configuração do PM2

```javascript
// ecosystem.config.js
module.exports = {
  apps: [
    {
      name: 'nowbot-backend',
      script: 'dist/server.js',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      env: {
        NODE_ENV: 'production'
      }
    },
    {
      name: 'nowbot-frontend',
      script: 'serve',
      env: {
        PM2_SERVE_PATH: 'build',
        PM2_SERVE_PORT: 3000,
        PM2_SERVE_SPA: 'true',
        PM2_SERVE_HOMEPAGE: '/index.html'
      }
    }
  ]
};
```

## 4. Manutenção e Monitoramento

### 4.1 Scripts de Manutenção

#### 4.1.1 Backup
```bash
#!/bin/bash
# backup.sh

BACKUP_DIR="/backup/nowbot"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="nowbot"
DB_USER="nowbot"

# Criar diretório de backup
mkdir -p $BACKUP_DIR

# Backup do banco de dados
pg_dump -U $DB_USER $DB_NAME | gzip > "$BACKUP_DIR/db_$DATE.sql.gz"

# Backup dos arquivos de mídia
tar -czf "$BACKUP_DIR/media_$DATE.tar.gz" /home/deploy/nowbot-teste/media

# Backup das configurações
tar -czf "$BACKUP_DIR/config_$DATE.tar.gz" \
    /home/deploy/nowbot-teste/backend/.env \
    /home/deploy/nowbot-teste/frontend/.env \
    /etc/nginx/sites-available/nowbot

# Manter apenas os últimos 7 backups
find $BACKUP_DIR -name "db_*.sql.gz" -mtime +7 -delete
find $BACKUP_DIR -name "media_*.tar.gz" -mtime +7 -delete
find $BACKUP_DIR -name "config_*.tar.gz" -mtime +7 -delete
```

#### 4.1.2 Monitoramento
```bash
#!/bin/bash
# monitor.sh

echo "=== Status do Sistema ==="
date
echo

echo "=== Uso de CPU e Memória ==="
top -b -n 1 | head -n 20

echo "=== Espaço em Disco ==="
df -h

echo "=== Status dos Serviços ==="
systemctl status postgresql | grep Active
systemctl status nginx | grep Active
docker ps | grep redis-nowbot

echo "=== Logs do PM2 ==="
pm2 list

echo "=== Últimas Conexões WebSocket ==="
tail -n 50 /var/log/pm2/nowbot-backend-out.log | grep "connection"
```

## 5. Solução de Problemas

### 5.1 Problemas Comuns e Soluções

#### 5.1.1 Erro de Conexão com Banco de Dados
- **Sintoma**: Backend não inicia ou retorna erro de conexão
- **Solução**:
  ```bash
  sudo systemctl restart postgresql
  sudo -u postgres psql -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'nowbot';"
  ```

#### 5.1.2 Erro de WebSocket
- **Sintoma**: Conexões WebSocket caindo frequentemente
- **Solução**:
  ```bash
  pm2 restart nowbot-backend
  sudo systemctl restart nginx
  ```

#### 5.1.3 Erro de SSL
- **Sintoma**: Certificado expirado ou inválido
- **Solução**:
  ```bash
  sudo certbot renew --force-renewal
  sudo systemctl restart nginx
  ```

## 6. Melhorias Futuras

### 6.1 Performance
- Implementar cache Redis para queries frequentes
- Otimizar consultas ao banco de dados
- Implementar lazy loading para imagens
- Adicionar compressão de mídia

### 6.2 Segurança
- Implementar rate limiting por IP
- Adicionar autenticação 2FA
- Melhorar política de senhas
- Implementar audit logs

### 6.3 Funcionalidades
- Chatbot com IA para triagem
- Sistema de avaliação de atendimento
- Dashboard personalizado
- Relatórios avançados
- Integração com CRM

## 7. Referências

### 7.1 Documentação Oficial
- [Node.js](https://nodejs.org/docs)
- [React.js](https://reactjs.org/docs)
- [PostgreSQL](https://www.postgresql.org/docs)
- [Redis](https://redis.io/documentation)
- [Nginx](https://nginx.org/en/docs)
- [PM2](https://pm2.keymetrics.io/docs)

### 7.2 Recursos Adicionais
- [WhatsApp Business API](https://developers.facebook.com/docs/whatsapp)
- [Docker](https://docs.docker.com)
- [Let's Encrypt](https://letsencrypt.org/docs)

EOL

echo -e "${GREEN}Gerando PDF...${NC}"
pandoc manual.md \
    -o "Manual_Tecnico_NowBot_v6.0.0.pdf" \
    --from markdown+yaml_metadata_block+raw_html \
    --template eisvogel \
    --table-of-contents \
    --toc-depth 3 \
    --number-sections \
    --top-level-division=chapter \
    --highlight-style tango \
    --pdf-engine=xelatex \
    --variable geometry:margin=1in \
    --variable links-as-notes=true \
    --variable papersize=a4 \
    --variable fontsize=11pt \
    --variable monofont="DejaVu Sans Mono" \
    --variable monofontoptions=Scale=0.9 \
    --variable urlcolor=blue \
    --variable linkcolor=blue \
    --variable babel-lang=brazilian

echo -e "${GREEN}Manual gerado com sucesso!${NC}"
echo -e "O arquivo PDF está disponível em: $(pwd)/Manual_Tecnico_NowBot_v6.0.0.pdf" 