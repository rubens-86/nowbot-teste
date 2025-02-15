#!/bin/bash

# Cores para output
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}Configurando frontend do NowBot...${NC}"

cd /home/deploy/nowbot/frontend

# Configurar variáveis de ambiente
cat > .env << EOF
REACT_APP_BACKEND_URL=https://api.nowbot.online
REACT_APP_HOURS_CLOSE_TICKETS_AUTO=24
EOF

# Configurar tema personalizado
cat > src/theme.js << EOF
const theme = {
  palette: {
    primary: {
      main: '#025A9D',
      dark: '#01355D',
      light: '#0386E9',
      contrastText: '#fff'
    },
    secondary: {
      main: '#0261AA',
      dark: '#024883',
      light: '#0386E9',
      contrastText: '#fff'
    }
  },
  typography: {
    fontFamily: [
      '-apple-system',
      'BlinkMacSystemFont',
      '"Segoe UI"',
      'Roboto',
      '"Helvetica Neue"',
      'Arial',
      'sans-serif',
    ].join(','),
  },
};

export default theme;
EOF

# Instalar dependências e construir
npm install
npm run build

# Configurar PM2
pm2 start npm --name "nowbot-frontend" -- start
pm2 save

echo -e "${GREEN}Frontend configurado com sucesso!${NC}" 