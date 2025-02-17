import Redis from "ioredis";
import { REDIS_URI_CONNECTION, redisConfig } from "../config/redis";
import util from "util";
import * as crypto from "crypto";
import { logger } from "../utils/logger";

const redis = new Redis(REDIS_URI_CONNECTION, redisConfig);

redis.on('error', (err) => {
  logger.error('Redis Client Error:', err);
});

redis.on('connect', () => {
  logger.info('Redis Client Connected');
});

redis.on('ready', () => {
  logger.info('Redis Client Ready');
});

function encryptParams(params: any) {
  const str = JSON.stringify(params);
  return crypto.createHash("sha256").update(str).digest("base64");
}

export default redis; 