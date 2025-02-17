# NowBot - Sistema de Atendimento Multicanal

## Descrição
O NowBot é um sistema de atendimento multicanal que integra WhatsApp e outros canais de comunicação em uma única plataforma.

## Requisitos do Sistema
- Node.js 20.x
- PostgreSQL 12+
- Redis 6+
- Docker e Docker Compose
- PM2 (global)

## Estrutura do Projeto
```
.
├── backend/           # API e lógica de negócios
├── frontend/          # Interface do usuário
├── scripts/          # Scripts de instalação e manutenção
└── docs/            # Documentação
```

## Instalação

### Ambiente de Desenvolvimento
1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/nowbot.git
cd nowbot
```

2. Instale as dependências:
```bash
cd backend && npm install
cd ../frontend && npm install
```

3. Configure as variáveis de ambiente:
```bash
cp backend/.env.example backend/.env
cp frontend/.env.example frontend/.env
```

4. Inicie os serviços:
```bash
# No diretório backend
npm run dev

# No diretório frontend
npm start
```

### Ambiente de Produção
1. Execute o script de instalação:
```bash
./scripts/install-nowbot.sh
```

2. Configure o Nginx:
```bash
./scripts/setup-nginx.sh
```

3. Inicie os serviços:
```bash
pm2 start ecosystem.config.js
```

## Funcionalidades Principais
- Integração com WhatsApp
- Gerenciamento de tickets
- Chat em tempo real
- Filas de atendimento
- Relatórios e dashboards
- Sistema de tags e categorização
- Campanhas e mensagens em massa

## Manutenção
- Backup automático diário
- Monitoramento via PM2
- Logs centralizados
- Atualizações automáticas

## Suporte
Para suporte, entre em contato através do email: suporte@nowbot.com.br

## Licença
Este projeto é proprietário e seu uso é restrito. Todos os direitos reservados. 