import net from 'net';
import bunyan from 'bunyan';
import autoincr from 'autoincr';
import Operation from './operation';
import Macro from './macro';
import config from '../config';

const log = bunyan.createLogger({ name: 'hal-server' });
const frame = autoincr();
let startGame = false;

function serializeOperation(operation) {
  const operationSerialized = JSON.stringify(operation)
    .replace('{', '')
    .replace('}', '')
    .replace('"id":', '')
    .replace('"operation":', '');
  return operationSerialized;
}

export default class Hal {
  static start() {
    const server = net.createServer();

    server.on('connection', (socket) => {
      log.info('client connected');
      Hal.send({ operation: 'ready' }, socket);

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
    socket.write(`${JSON.stringify(data)}\n`);
    // socket.pipe(socket);
  }

  static decode(buffer) {
    const dataStrRaw = buffer.toString();
    const data = JSON.parse(dataStrRaw.replace('\n', ''));
    return data;
  }

  static parse(data) {
    const response = {};
    switch (data.cmd) {
      case 'connect':
        response.cmd = 'connect';
        response.code = 200;
        response.data = 'ready';
        return response;

      case 'getOperations':
        log.info('ask for operation');
        if (startGame) {
          return Hal.frameResponse();
        }
        startGame = true;
        return Hal.startResponse();

      case 'memoryReadByte':
        // log.info('memoryReadByte : ', data);
        if (data.data > 0 && data.data < 255) {
          log.info('GRADIUS IS DEAD');
        }
        return { cmd: 'memoryReadByte', status: 'ready' };

      default:
        response.code = '500';
        response.status = 'ready';
        return response;
    }
  }

  static frameResponse() {
    return new Operation()
      .add(
        Macro.joypadWriteRandom({
          a: 0.5,
          b: 0.5,
          right: 0.5,
          left: 0.5,
          down: 0.5,
          up: 0.5,
        }),
      )
      .memoryReadByte(0x004c)
      .emuFrameAdvance()
      .commit();
  }

  static startResponse() {
    const operation = new Operation();
    operation
      .add(Macro.init('normal'))
      .add(Macro.start())
      .emuFrameAdvance();
    /*
    for (let i = 0; i < 2000; i += 1) {
      operation.add(Macro.joypadWriteRandom({
        a: 0.5,
        b: 0.5,
        right: 0.5,
        left: 0.5,
        down: 0.5,
        up: 0.5,
      }))
        .emuFrameAdvance()
        .memoryReadByte(0x004c);
    }
    */
    return operation.commit();
  }
}
