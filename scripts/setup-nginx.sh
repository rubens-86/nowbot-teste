#!/bin/bash

# Instala o Nginx
sudo apt install nginx -y

# Configura o Nginx para os subdomínios
NGINX_CONF="/etc/nginx/sites-available/nowbot"
sudo bash -c "cat > $NGINX_CONF" <<EOL
server {
    listen 80;
    server_name app.nowbot.online api.nowbot.online;

    location / {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOL

# Ativa a configuração do Nginx
sudo ln -s $NGINX_CONF /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# Instala Certbot para SSL
sudo apt install certbot python3-certbot-nginx -y

# Gera certificados SSL
sudo certbot --nginx -d app.nowbot.online -d api.nowbot.online --non-interactive --agree-tos -m rubox1000@gmail.com 