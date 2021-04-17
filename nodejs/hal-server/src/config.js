import pkg from '../package.json';

const config = {
  app: {
    server: {
      host: process.env.APP_SERVER_HOST || '0.0.0.0',
      port: process.env.APP_SERVER_PORT || 8080,
    },
  },
  health: {
    server: {
      host: process.env.HEALTH_SERVER_HOST || '0.0.0.0',
      port: process.env.HEALTH_SERVER_PORT || 8081,
    },
  },
  logger: {
    config: {
      name: pkg.name,
      streams: [{ level: 'debug', stream: process.stdout }],
    },
  },
};

export default config;
// export const { api } = config;
