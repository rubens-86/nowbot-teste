module.exports = {
  apps: [
    {
      name: 'nowbot-backend',
      script: './backend/dist/server.js',
      instances: 1,
      exec_mode: 'fork',
      watch: false,
      max_memory_restart: '1G',
      env: {
        NODE_ENV: 'production',
        PORT: 8080
      },
      error_file: './logs/backend-error.log',
      out_file: './logs/backend-out.log',
      time: true,
      autorestart: true,
      restart_delay: 5000,
      wait_ready: true,
      kill_timeout: 3000,
      listen_timeout: 10000
    },
    {
      name: 'nowbot-frontend',
      script: 'serve',
      env: {
        PM2_SERVE_PATH: './frontend/build',
        PM2_SERVE_PORT: 3000,
        PM2_SERVE_SPA: 'true',
        PM2_SERVE_HOMEPAGE: '/index.html'
      },
      error_file: './logs/frontend-error.log',
      out_file: './logs/frontend-out.log',
      time: true,
      autorestart: true
    }
  ],
  deploy: {
    production: {
      user: 'deploy',
      host: 'api.nowbot.online',
      ref: 'origin/main',
      repo: 'git@github.com:seu-usuario/nowbot.git',
      path: '/home/deploy/nowbot',
      'post-deploy': 'cd backend && npm install && npm run build && cd ../frontend && npm install && npm run build && pm2 reload ecosystem.config.js'
    }
  }
}; 