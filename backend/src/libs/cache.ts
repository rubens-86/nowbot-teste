import Redis from "ioredis";
import { REDIS_URI_CONNECTION, redisConfig } from "../config/redis";
import * as crypto from "crypto";
import { logger } from "../utils/logger";

const redis = new Redis(redisConfig);

redis.on('error', (err) => {
  logger.error('Redis Client Error:', err.message);
  if (err.message.includes('NOAUTH')) {
    logger.error('Erro de autenticação no Redis - Verificando credenciais...');
  }
});

redis.on('connect', () => {
  logger.info('Redis Client Connected');
});

redis.on('ready', () => {
  logger.info('Redis Client Ready');
});

redis.on('reconnecting', () => {
  logger.info('Reconectando ao Redis...');
});

function encryptParams(params: any) {
  const str = JSON.stringify(params);
  return crypto.createHash("sha256").update(str).digest("base64");
}

export default redis; 