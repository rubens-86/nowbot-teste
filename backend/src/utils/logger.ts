export const logger = {
  info: (message: string | any, ...args: any[]) => {
    console.log(`INFO [${new Date().toLocaleTimeString()}]:`, message, ...args);
  },
  error: (message: string | any, ...args: any[]) => {
    console.error(`ERROR [${new Date().toLocaleTimeString()}]:`, message, ...args);
  },
  warn: (message: string | any, ...args: any[]) => {
    console.warn(`WARN [${new Date().toLocaleTimeString()}]:`, message, ...args);
  },
  debug: (message: string | any, ...args: any[]) => {
    if (process.env.NODE_ENV !== 'production') {
      console.debug(`DEBUG [${new Date().toLocaleTimeString()}]:`, message, ...args);
    }
  }
}; 