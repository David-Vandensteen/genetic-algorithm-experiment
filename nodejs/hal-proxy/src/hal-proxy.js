import Proxy from './lib/proxy';
import config from './config';

const { server } = config;

// eslint-disable-next-line no-unused-vars
const proxy = new Proxy(server);
