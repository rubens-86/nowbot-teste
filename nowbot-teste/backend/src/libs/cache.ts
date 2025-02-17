import Redis from "ioredis";
import { logger } from "../utils/logger";
import * as crypto from "crypto";
import { redisConfig } from "../config/redis";

// Criar cliente Redis com configuração completa
const redis = new Redis({
  ...redisConfig,
  retryStrategy: (times) => {
    const delay = Math.min(times * 500, 2000);
    logger.info(`Tentando reconectar ao Redis em ${delay}ms... (tentativa ${times})`);
    if (times > 5) {
      logger.error('Falha na conexão com Redis após 5 tentativas');
      return null;
    }
    return delay;
  }
});

// Eventos de monitoramento
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
  logger.info('Redis pronto para uso');
});

redis.on('reconnecting', () => {
  logger.info('Reconectando ao Redis...');
});

// Funções auxiliares
function encryptParams(params: any) {
  const str = JSON.stringify(params);
  return crypto.createHash("sha256").update(str).digest("base64");
}

// Funções exportadas com tratamento de erro aprimorado
export async function set(key: string, value: string) {
  try {
    return await redis.set(key, value);
  } catch (error) {
    logger.error('Erro ao definir valor no Redis:', error);
    throw error;
  }
}

export async function get(key: string) {
  try {
    return await redis.get(key);
  } catch (error) {
    logger.error('Erro ao obter valor do Redis:', error);
    throw error;
  }
}

export async function del(key: string) {
  try {
    return await redis.del(key);
  } catch (error) {
    logger.error('Erro ao deletar valor do Redis:', error);
    throw error;
  }
}

export async function setFromParams(key: string, params: any, value: string) {
  try {
    const finalKey = `${key}:${encryptParams(params)}`;
    return await redis.set(finalKey, value);
  } catch (error) {
    logger.error('Erro ao definir valor com parâmetros no Redis:', error);
    throw error;
  }
}

export async function getFromParams(key: string, params: any) {
  try {
    const finalKey = `${key}:${encryptParams(params)}`;
    return await redis.get(finalKey);
  } catch (error) {
    logger.error('Erro ao obter valor com parâmetros do Redis:', error);
    throw error;
  }
}

export async function delFromParams(key: string, params: any) {
  try {
    const finalKey = `${key}:${encryptParams(params)}`;
    return await redis.del(finalKey);
  } catch (error) {
    logger.error('Erro ao deletar valor com parâmetros do Redis:', error);
    throw error;
  }
}

export async function getKeys(pattern: string) {
  try {
    return await redis.keys(pattern);
  } catch (error) {
    logger.error('Erro ao obter chaves do Redis:', error);
    throw error;
  }
}

export async function delFromPattern(pattern: string) {
  try {
    const all = await redis.keys(pattern);
    for (let item of all) {
      await redis.del(item);
    }
  } catch (error) {
    logger.error('Erro ao deletar valores por padrão do Redis:', error);
    throw error;
  }
}

export const cacheLayer = {
  set,
  setFromParams,
  get,
  getFromParams,
  getKeys,
  del,
  delFromParams,
  delFromPattern
};

export default redis;
