import { Server as SocketIO } from "socket.io";
import { Server } from "http";
import AppError from "../errors/AppError";
import { logger } from "../utils/logger";
import User from "../models/User";
import Queue from "../models/Queue";
import Ticket from "../models/Ticket";
import { verify } from "jsonwebtoken";
import authConfig from "../config/auth";
import { CounterManager } from "./counter";
import redis from "./cache";

let io: SocketIO;

export const initIO = async (httpServer: Server): Promise<SocketIO> => {
  io = new SocketIO(httpServer, {
    cors: {
      origin: process.env.FRONTEND_URL || "http://localhost:3000",
      methods: ["GET", "POST"],
      credentials: true
    },
    allowEIO3: true
  });

  io.on("connection", async socket => {
    logger.info("Client Connected");
    try {
      const { token } = socket.handshake.query;

      if (!token) {
        throw new Error("Token não fornecido");
      }

      const decoded = verify(token as string, authConfig.secret);
      const { id } = decoded as { id: number };

      const user = await User.findByPk(id, { include: [Queue] });
      
      if (!user) {
        throw new Error("Usuário não encontrado");
      }

      socket.on("joinChatBox", async (ticketId: string) => {
        logger.info(`User ${user.id} joined chat ${ticketId}`);
        socket.join(ticketId);
      });

      socket.on("leaveChatBox", async (ticketId: string) => {
        logger.info(`User ${user.id} left chat ${ticketId}`);
        socket.leave(ticketId);
      });

      socket.on("disconnect", async () => {
        logger.info(`User ${user.id} disconnected`);
      });

    } catch (err) {
      logger.error(err);
      socket.disconnect();
    }
  });

  return io;
};

export const getIO = (): SocketIO => {
  if (!io) {
    throw new AppError("Socket IO not initialized");
  }
  return io;
}; 