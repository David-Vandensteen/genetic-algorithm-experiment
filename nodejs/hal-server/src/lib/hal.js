import net from 'net';
import bunyan from 'bunyan';
import Operation from './operation';
import Macro from './macro';
import config from '../config';

const log = bunyan.createLogger({ name: 'hal-server' });

export default class Hal {
  static start() {
    const server = net.createServer();

    server.on('connection', (socket) => {
      log.info('client connected');
      // Hal.send({ status: 'ready' }, socket);

      socket.on('data', (buffer) => {
        const data = Hal.decode(buffer);
        // log.info('client send :', data);
        const response = Hal.parse(data);
        Hal.send(response, socket);
        // Hal.send({ status: 'ready' }, socket);
      });
    });

    server.on('close', () => {
      log.info('client disconnected');
    });

    server.on('error', (err) => {
      log.error(err);
    });

    server.on('listening', () => {
      log.info('server started');
    });

    server.on('data', (data) => {
      log.info('client send :', data);
    });
    server.listen(config.server.port, config.server.host);
  }

  static send(data, socket) {
    // log.info('server send : ', data);
    socket.write(`${JSON.stringify(data)}\n`);
    socket.pipe(socket);
  }

  static decode(buffer) {
    const dataStrRaw = buffer.toString();
    const dataSanity = JSON.parse(dataStrRaw);
    return dataSanity;
  }

  static parse(data) {
    let response = {};
    switch (data.cmd) {
      case 'connect':
        response.cmd = 'connect';
        response.code = 200;
        response.data = 'ready';
        return response;

      case 'getOperations':
        log.info('ask for operation');
        response = new Operation()
          .add(Macro.joypadWriteRandom({
            a: 0.5,
            b: 0.5,
            right: 0.5,
            left: 0.5,
            down: 0.5,
            up: 0.5,
          }, {
            autoFrame: true,
            quantity: 10,
          }))
          .commit();
        return Hal.response();

      case 'memoryReadByte':
        log.info('memoryReadByte : ', data);
        return { cmd: 'memoryReadByte', status: 'ready' };

      default:
        response.code = '500';
        response.status = 'ready';
        return response;
    }
  }

  static response() {
    return new Operation()
      .add(Macro.init('normal'))
      .memoryReadByte(0x004c)
      .add(Macro.start())
      .memoryReadByte(0x004c)
      .emuFrameAdvance()
      .memoryReadByte(0x004c)
      .emuFrameAdvance()
      .memoryReadByte(0x004c)
      .emuFrameAdvance()
      .add(Macro.joypadWriteRandom({
        a: 0.5,
        b: 0.5,
        right: 0.5,
        left: 0.5,
        down: 0.5,
        up: 0.5,
      }, {
        autoFrame: true,
        quantity: 2000,
      }))
      .commit();
  }
}
