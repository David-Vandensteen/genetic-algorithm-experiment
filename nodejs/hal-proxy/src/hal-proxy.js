import Proxy from './lib/proxy';
import params from './lib/params';
import config from './config';

const { server } = config;
const { log } = console;

if (params.process()['--post']) {
  log('method post');
  log('query: ', `${server}/operations?lastOp=${params.process()['--lastOp']}&alive=${params.process()['--alive']}`);
  let i = 0;
  // eslint-disable-next-line no-constant-condition
  while (true) {
    // eslint-disable-next-line no-unused-vars
    i += 1;
  }
} else {
  // eslint-disable-next-line no-unused-vars
  const proxy = new Proxy(server);
}
