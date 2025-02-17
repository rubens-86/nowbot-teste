#!/bin/bash

# Instala Node.js e npm
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Instala Docker
curl -fsSL https://get.docker.com | sudo bash
sudo usermod -aG docker $USER

# Instala Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Entrar na pasta correta
cd /home/deploy/nowbot-teste/nowbot-teste
ls -la

# Se as pastas backend e frontend estiverem aqui, vamos mover tudo para cima
mv * ../ 2>/dev/null
mv .* ../ 2>/dev/null || true
cd ..
rmdir nowbot-teste

# Verificar a estrutura novamente
ls -la 