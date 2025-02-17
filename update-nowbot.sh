#!/bin/bash

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Iniciando atualização do NowBot...${NC}"

# Verificar se está rodando como usuário deploy
if [ "$USER" != "deploy" ]; then
    echo -e "${RED}Este script deve ser executado como usuário deploy${NC}"
    exit 1
fi

# Entrar no diretório do projeto
cd /home/deploy/nowbot-teste

# Backup do banco de dados
echo -e "${GREEN}Fazendo backup do banco de dados...${NC}"
pg_dump -U nowbot nowbot | gzip > "/home/deploy/backups/db_backup_$(date +%Y%m%d_%H%M%S).sql.gz"

# Parar os serviços
echo -e "${GREEN}Parando serviços...${NC}"
pm2 stop all

# Atualizar backend
echo -e "${GREEN}Atualizando backend...${NC}"
cd backend
npm install
npm run build

# Atualizar frontend
echo -e "${GREEN}Atualizando frontend...${NC}"
cd ../frontend
npm install
npm run build

# Reiniciar serviços
echo -e "${GREEN}Reiniciando serviços...${NC}"
cd ..
pm2 start all
pm2 save

echo -e "${GREEN}Atualização concluída!${NC}" 