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

      socket.on('data', (buffer) => {
        const data = Hal.decode(buffer);
        log.info('client send :', data);
        Hal.reply(data, socket);
        Hal.send({ cmd: 'ready' }, socket);
      });
      // Hal.send(Hal.response(), socket);
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
    socket.write(`${JSON.stringify(data)}\n`);
    socket.pipe(socket);
  }

  static decode(buffer) {
    const dataStrRaw = buffer.toString();
    const dataSanity = JSON.parse(dataStrRaw);
    return dataSanity;
  }

  static reply(data, socket) {
    switch (data.cmd) {
      case 'connect':
        log.info('connect command is received');
        Hal.send(data, socket);
        return 200;
      case 'getOperation':
        log.info('ask for operation');
        return new Operation()
          .add(Macro.joypadWriteRandom({
            a: 0.5,
            b: 0.5,
            right: 0.5,
            left: 0.5,
            down: 0.5,
            up: 0.5,
          }, {
            autoFrame: true,
            quantity: 100,
          }))
          .commit();

      default:
        return 500;
    }
  }

  static response() {
    return new Operation()
      .add(Macro.init('normal'))
      .add(Macro.start())
      .add(Macro.joypadWriteRandom({
        a: 0.5,
        b: 0.5,
        right: 0.5,
        left: 0.5,
        down: 0.5,
        up: 0.5,
      }, {
        autoFrame: true,
        quantity: 100,
      }))
      .commit();
  }
}
