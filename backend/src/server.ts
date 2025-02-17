import gracefulShutdown from "http-graceful-shutdown";
import app from "./app";
import { initIO } from "./libs/socket";
import { logger } from "./utils/logger";
import { StartAllWhatsAppsSessions } from "./services/WbotServices/StartAllWhatsAppsSessions";
import Company from "./models/Company";
import { startQueueProcess } from "./queues";
import { TransferTicketQueue } from "./wbotTransferTicketQueue";
import cron from "node-cron";

const server = app.listen(process.env.PORT, async () => {
  try {
    // Inicializar Socket.IO
    await initIO(server);
    logger.info("Socket.IO initialized successfully");

    // Iniciar sessões do WhatsApp
    const companies = await Company.findAll();
    const allPromises = companies.map(c => StartAllWhatsAppsSessions(c.id));
    await Promise.all(allPromises);

    // Iniciar processamento da fila
    startQueueProcess();

    logger.info(`Server started on port: ${process.env.PORT}`);
  } catch (error) {
    logger.error("Error during server initialization:", error);
  }
});

// Configurar cron job para transferência de tickets
cron.schedule("* * * * *", async () => {
  try {
    logger.info("Serviço de transferencia de tickets iniciado");
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
  },
  finally: () => {
    logger.info("Servidor desligado com sucesso.");
  }
}); 