import { RedisOptions } from 'ioredis';

const redisConfig: RedisOptions = {
  host: '127.0.0.1',
  port: 6379,
  password: 'Dbranco20!',
  showFriendlyErrorStack: true,
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
  }
};

export default redisConfig;