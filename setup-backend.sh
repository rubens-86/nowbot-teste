#!/bin/bash

# Cores para output
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}Configurando backend do NowBot...${NC}"

cd /home/deploy/nowbot/backend

# Configurar variáveis de ambiente
cat > .env << EOF
NODE_ENV=production
BACKEND_URL=https://api.nowbot.online
FRONTEND_URL=https://app.nowbot.online
PROXY_PORT=443
PORT=8080

DB_DIALECT=postgres
DB_HOST=localhost
DB_PORT=5432
DB_USER=nowbot
DB_PASS=Dbranco20!
DB_NAME=nowbot

JWT_SECRET=$(openssl rand -base64 32)
JWT_REFRESH_SECRET=$(openssl rand -base64 32)

REDIS_URI=redis://:Dbranco20!@127.0.0.1:6379
REDIS_OPT_LIMITER_MAX=1
REGIS_OPT_LIMITER_DURATION=3000

USER_LIMIT=100
CONNECTIONS_LIMIT=10
CLOSED_SEND_BY_ME=true

# EMAIL
MAIL_HOST=smtp.gmail.com
MAIL_USER=contato@nowbot.com.br
MAIL_PASS=sua_senha_do_email
MAIL_FROM=contato@nowbot.com.br
MAIL_PORT=465
EOF

# Instalar dependências
npm install

# Construir o projeto
npm run build

# Executar migrações do banco de dados
npx sequelize db:migrate
npx sequelize db:seed:all

# Configurar PM2
pm2 start dist/server.js --name "nowbot-backend"
pm2 save

echo -e "${GREEN}Backend configurado com sucesso!${NC}" 