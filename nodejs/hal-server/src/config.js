export default {
  server: {
    host: process.env.HAL_SERVER_HOST || '0.0.0.0',
    port: process.env.HAL_SERVER_PORT || 81,
  },
};
