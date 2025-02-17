import Redis from "ioredis";
import redisConfig from "../config/redis";
import * as crypto from "crypto";
import { logger } from "../utils/logger";

const redis = new Redis(redisConfig);

redis.on('error', (err) => {
  logger.error('Erro na conexão com Redis:', err.message);
  if (err.message.includes('NOAUTH')) {
    logger.error('Erro de autenticação no Redis - Verificando credenciais...');
  }
});

redis.on('connect', () => {
  logger.info('Conectado ao Redis com sucesso');
});

redis.on('ready', () => {
  logger.info('Cliente Redis pronto para uso');
});

redis.on('reconnecting', () => {
  logger.info('Reconectando ao Redis...');
});

function encryptParams(params: any) {
  const str = JSON.stringify(params);
  return crypto.createHash("sha256").update(str).digest("base64");
}

export default redis; 