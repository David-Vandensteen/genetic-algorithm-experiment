import getFileFromUrl from '@appgeist/get-file-from-url';
import Proxy from './lib/proxy';
import params from './lib/params';
import { server, rom } from './config';

const { log } = console;

if (params.process()['--download']) {
  log('download rom', params.process()['--download']);
  log(`${server.url}/downloads/roms/${params.process()['--download']}`);
  getFileFromUrl({
    url: `${server.url}/downloads/roms/${params.process()['--download']}`,
    file: `${rom.path}\\${params.process()['--download']}.zip`,
  }).then(() => { log('download finish'); });
}

if (params.process()['--post'] && !params.process()['--download']) {
  log('method post');
  log('query: ', `${server.url}/operations?lastOp=${params.process()['--lastOp']}&alive=${params.process()['--alive']}`);
} else {
  // eslint-disable-next-line no-unused-vars
  const proxy = new Proxy(server.url);
}
