import { Router } from "express";

import userRoutes from "./userRoutes";
import authRoutes from "./authRoutes";
import settingRoutes from "./settingRoutes";
import contactRoutes from "./contactRoutes";
import ticketRoutes from "./ticketRoutes";
import whatsappRoutes from "./whatsappRoutes";
import messageRoutes from "./messageRoutes";
import whatsappSessionRoutes from "./whatsappSessionRoutes";
import queueRoutes from "./queueRoutes";
import companyRoutes from "./companyRoutes";
import planRoutes from "./planRoutes";
import ticketNoteRoutes from "./ticketNoteRoutes";
import quickMessageRoutes from "./quickMessageRoutes";
import helpRoutes from "./helpRoutes";
import dashboardRoutes from "./dashboardRoutes";
import queueOptionRoutes from "./queueOptionRoutes";
import scheduleRoutes from "./scheduleRoutes";
import tagRoutes from "./tagRoutes";
import contactListRoutes from "./contactListRoutes";
import contactListItemRoutes from "./contactListItemRoutes";
import campaignRoutes from "./campaignRoutes";
import campaignSettingRoutes from "./campaignSettingRoutes";
import announcementRoutes from "./announcementRoutes";
import chatRoutes from "./chatRoutes";
import invoiceRoutes from "./invoicesRoutes";
import subscriptionRoutes from "./subScriptionRoutes";
import ticketTagRoutes from "./ticketTagRoutes";
import filesRoutes from "./filesRoutes";
import promptRoutes from "./promptRouter";
import queueIntegrationRoutes from "./queueIntegrationRoutes";
import forgotsRoutes from "./forgotPasswordRoutes";
import versionRouter from "./versionRoutes";

const routes = Router();

// Rota de verificação de saúde do sistema
routes.get('/api/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    message: 'Sistema funcionando normalmente'
  });
});

// Rotas de autenticação
routes.use("/auth", authRoutes);

// Rotas principais do sistema
routes.use("/", userRoutes);
routes.use("/", settingRoutes);
routes.use("/", contactRoutes);
routes.use("/", ticketRoutes);
routes.use("/", whatsappRoutes);
routes.use("/", messageRoutes);
routes.use("/", whatsappSessionRoutes);
routes.use("/", queueRoutes);
routes.use("/", companyRoutes);
routes.use("/", planRoutes);
routes.use("/", ticketNoteRoutes);
routes.use("/", quickMessageRoutes);
routes.use("/", helpRoutes);
routes.use("/", dashboardRoutes);
routes.use("/", queueOptionRoutes);
routes.use("/", scheduleRoutes);
routes.use("/", tagRoutes);

// Rotas de gestão de contatos e campanhas
routes.use("/", contactListRoutes);
routes.use("/", contactListItemRoutes);
routes.use("/", campaignRoutes);
routes.use("/", campaignSettingRoutes);

// Rotas de comunicação e chat
routes.use("/", announcementRoutes);
routes.use("/", chatRoutes);

// Rotas de faturamento e assinatura
routes.use("/", subscriptionRoutes);
routes.use("/", invoiceRoutes);

// Rotas de gerenciamento de tickets e arquivos
routes.use("/", ticketTagRoutes);
routes.use("/", filesRoutes);

// Rotas de integração e configuração
routes.use("/", promptRoutes);
routes.use("/", queueIntegrationRoutes);
routes.use("/", forgotsRoutes);
routes.use("/", versionRouter);

export default routes;
