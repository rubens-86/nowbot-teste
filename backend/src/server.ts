import gracefulShutdown from "http-graceful-shutdown";
import app from "./app";
import { initIO } from "./libs/socket";
import { logger } from "./utils/logger";
import { StartAllWhatsAppsSessions } from "./services/WbotServices/StartAllWhatsAppsSessions";
import Company from "./models/Company";
import { startQueueProcess } from "./queues";
import { TransferTicketQueue } from "./wbotTransferTicketQueue";
import cron from "node-cron";
import redis from "./libs/cache";

const server = app.listen(process.env.PORT || 8080, async () => {
  try {
    logger.info("Servidor iniciado na porta:", process.env.PORT || 8080);
  } catch (error) {
    logger.error("Erro ao iniciar servidor:", error);
  }
});

// Inicializar Socket.IO
let retries = 0;
const maxRetries = 5;
const retryDelay = 5000;

const initializeServices = async () => {
  try {
    // Verificar conexão com Redis
    if (redis.status !== 'ready') {
      if (retries >= maxRetries) {
        throw new Error('Falha ao conectar ao Redis após várias tentativas');
      }
      logger.info(`Tentativa ${retries + 1} de ${maxRetries} de conectar ao Redis...`);
      retries++;
      setTimeout(initializeServices, retryDelay);
      return;
    }

    // Inicializar Socket.IO
    await initIO(server);
    logger.info("Socket.IO inicializado com sucesso");

    // Iniciar sessões do WhatsApp
    const companies = await Company.findAll();
    await Promise.all(companies.map(c => StartAllWhatsAppsSessions(c.id)));
    logger.info("Sessões do WhatsApp iniciadas");

    // Iniciar processamento da fila
    startQueueProcess();
    logger.info("Processamento de fila iniciado");

  } catch (error) {
    logger.error("Erro durante a inicialização dos serviços:", error);
    if (retries < maxRetries) {
      retries++;
      setTimeout(initializeServices, retryDelay);
    }
  }
};

// Iniciar serviços
initializeServices();

// Configurar cron job para transferência de tickets
cron.schedule("* * * * *", async () => {
  try {
    await TransferTicketQueue();
  } catch (error) {
    logger.error("Erro no serviço de transferência de tickets:", error);
  }
});

// Configurar graceful shutdown
gracefulShutdown(server, {
  signals: "SIGINT SIGTERM",
  timeout: 30000,
  development: process.env.NODE_ENV !== "production",
  onShutdown: async () => {
    logger.info("Servidor está sendo desligado graciosamente...");
    redis.disconnect();
  },
  finally: () => {
    logger.info("Servidor desligado com sucesso.");
  }
}); 