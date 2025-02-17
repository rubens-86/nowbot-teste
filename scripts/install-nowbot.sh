#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Iniciando instalação do NowBot...${NC}"

# Atualizar o sistema
echo -e "${GREEN}Atualizando o sistema...${NC}"
apt update && apt upgrade -y

# Instalar dependências básicas
echo -e "${GREEN}Instalando dependências básicas...${NC}"
apt install -y git curl wget nano software-properties-common

# Instalar Node.js 20.x
echo -e "${GREEN}Instalando Node.js...${NC}"
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
apt install -y nodejs

# Instalar Docker
echo -e "${GREEN}Instalando Docker...${NC}"
curl -fsSL https://get.docker.com | sudo bash
usermod -aG docker $USER

# Instalar Docker Compose
echo -e "${GREEN}Instalando Docker Compose...${NC}"
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Instalar PM2
echo -e "${GREEN}Instalando PM2...${NC}"
npm install -g pm2

# Criar usuário deploy
echo -e "${GREEN}Criando usuário deploy...${NC}"
useradd -m -p $(openssl passwd -crypt Dbranco20!) -s /bin/bash -G sudo deploy
usermod -aG docker deploy

# Configurar PostgreSQL
echo -e "${GREEN}Configurando PostgreSQL...${NC}"
apt install -y postgresql postgresql-contrib
sudo -u postgres psql -c "CREATE DATABASE nowbot;"
sudo -u postgres psql -c "CREATE USER nowbot WITH ENCRYPTED PASSWORD 'Dbranco20!';"
sudo -u postgres psql -c "ALTER USER nowbot WITH SUPERUSER;"

# Configurar Redis
echo -e "${GREEN}Configurando Redis...${NC}"
docker run --name redis-nowbot -p 6379:6379 --restart always -d redis redis-server --requirepass Dbranco20!

# Instalar Nginx
echo -e "${GREEN}Instalando e configurando Nginx...${NC}"
apt install -y nginx certbot python3-certbot-nginx

# Criar configuração do Nginx
cat > /etc/nginx/sites-available/nowbot << 'EOF'
server {
    server_name app.nowbot.online;
    
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
    server_name api.nowbot.online;
    
    location / {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

# Ativar configuração do Nginx
ln -s /etc/nginx/sites-available/nowbot /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default
nginx -t && systemctl restart nginx

# Configurar SSL
echo -e "${GREEN}Configurando SSL...${NC}"
certbot --nginx -d app.nowbot.online -d api.nowbot.online --non-interactive --agree-tos --email contato@nowbot.com.br

echo -e "${GREEN}Instalação básica concluída!${NC}" 