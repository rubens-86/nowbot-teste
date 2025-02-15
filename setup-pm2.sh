#!/bin/bash

# Instala o PM2 globalmente
sudo npm install -g pm2

# Inicia a aplicação com PM2
pm2 start /home/deploy/atendechat/backend/dist/server.js --name nowbot

# Configura o PM2 para iniciar com o sistema
pm2 startup ubuntu
pm2 save 