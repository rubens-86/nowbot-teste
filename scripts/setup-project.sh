#!/bin/bash

# Diretório do projeto
PROJECT_DIR="/home/deploy/atendechat/backend"

# Clona o repositório (substitua pela URL do seu repositório)
git clone https://github.com/seu-usuario/seu-repositorio.git $PROJECT_DIR

# Entra no diretório do projeto
cd $PROJECT_DIR

# Copia o arquivo de exemplo .env
cp .env.example .env

# Atualiza o arquivo .env com suas configurações
sed -i 's|BACKEND_URL=http://localhost|BACKEND_URL=https://api.nowbot.online|' .env
sed -i 's|FRONTEND_URL=http://localhost:3000|FRONTEND_URL=https://app.nowbot.online|' .env
sed -i 's|DB_NAME=db_name|DB_NAME=Nowbot-system|' .env
sed -i 's|DB_USER=user|DB_USER=root|' .env
sed -i 's|DB_PASS=senha|DB_PASS=Dbranco20!|' .env
sed -i 's|REDIS_URI=redis://:123456@127.0.0.1:6379|REDIS_URI=redis://:Dbranco20!@127.0.0.1:6379|' .env
sed -i 's|MAIL_USER="seu@gmail.com"|MAIL_USER="rubox1000@gmail.com"|' .env
sed -i 's|MAIL_PASS="SuaSenha"|MAIL_PASS="SuaSenhaDoEmail"|' .env

# Instala as dependências do projeto
npm install

# Build do projeto
npm run build

# Executa migrações e seeds
npm run db:migrate
npm run db:seed 