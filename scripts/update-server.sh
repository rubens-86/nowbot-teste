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

# Parar PM2
pm2 kill

# Matar todos os processos node (como root)
sudo pkill -9 -f node

# Matar qualquer processo usando as portas 3000 e 8081
sudo fuser -k 3000/tcp
sudo fuser -k 8081/tcp

# Verificar se as portas estão realmente livres
sudo lsof -i :3000
sudo lsof -i :8081

# Backup do banco de dados
echo -e "${GREEN}Fazendo backup do banco de dados...${NC}"
pg_dump -U nowbot nowbot | gzip > "/home/deploy/backups/db_backup_$(date +%Y%m%d_%H%M%S).sql.gz"

# Atualizar backend
echo -e "${GREEN}Atualizando backend...${NC}"
cd /home/deploy/nowbot-teste/backend
npm install
npm run build

# Atualizar frontend
echo -e "${GREEN}Atualizando frontend...${NC}"
cd /home/deploy/nowbot-teste/frontend
npm install
npm run build

# Reiniciar serviços
echo -e "${GREEN}Reiniciando serviços...${NC}"
pm2 restart all

# Parar serviços
pm2 delete nowbot-backend
docker stop redis-nowbot
docker rm redis-nowbot

# Criar novo container Redis usando localhost
docker run -d \
  --name redis-nowbot \
  --restart always \
  -p 6379:6379 \
  redis:6

# Verificar se o container está rodando
docker ps | grep redis-nowbot

# Agora vamos testar o Redis corretamente
docker exec -it redis-nowbot redis-cli
# Dentro do redis-cli, digite:
ping

echo -e "${GREEN}Atualização concluída!${NC}"