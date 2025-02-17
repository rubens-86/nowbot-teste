export const REDIS_URI_CONNECTION = process.env.REDIS_URI || "redis://:Dbranco20!@127.0.0.1:6379";
export const REDIS_OPT_LIMITER_MAX = process.env.REDIS_OPT_LIMITER_MAX || 1;
export const REDIS_OPT_LIMITER_DURATION = process.env.REDIS_OPT_LIMITER_DURATION || 3000;

export const redisConfig = {
  host: '127.0.0.1',
  port: 6379,
  password: 'Dbranco20!',
  enableReadyCheck: true,
  maxRetriesPerRequest: 3,
  retryStrategy: (times: number) => {
    if (times > 3) {
      console.error('Falha na conexão com Redis após 3 tentativas');
      return null;
    }
    return Math.min(times * 500, 2000);
  },
  reconnectOnError: (err: Error) => {
    const targetErrors = ['READONLY', 'ECONNREFUSED', 'ETIMEDOUT'];
    return targetErrors.some(e => err.message.includes(e));
  },
  showFriendlyErrorStack: true,
  enableOfflineQueue: true,
  connectTimeout: 10000,
  family: 4,
  db: 0,
  keepAlive: 10000,
  tls: null
}; 