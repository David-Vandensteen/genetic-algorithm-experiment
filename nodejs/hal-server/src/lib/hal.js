import net from 'net';
import bunyan from 'bunyan';
// import autoincr from 'autoincr';
import config from '../config';

export default class Hal {
  constructor() {
    this.romHead = [];
    this.log = bunyan.createLogger({ name: 'hal-server ' });
    this.startGame = false;
  //    this.frame = autoincr();
  }

  start() {
    const server = net.createServer();

    server.on('connection', (socket) => {
      this.log.info('client is connected');
      Hal.send({ operation: 'ready' }, socket);

      socket.on('data', (buffer) => {
        const data = Hal.decode(buffer);
        const response = this.parse(data);
        Hal.send(response, socket);
      });
    });

    server.on('close', () => {
      this.log.info('client is disconnected');
    });

    server.on('error', (err) => {
      this.log.error(err);
    });

    server.on('listening', () => {
      this.log.info('server is started');
    });

    server.listen(config.server.port, config.server.host);
  }

  operationsInit() { // callback need to be implement on child class
    return this;
  }

  operationsUpdate() { // callback need to be implement on child class
    return this;
  }

  dead() { // callback need to be implement on child class
    return this;
  }

  static send(data, socket) {
    socket.write(`${JSON.stringify(data)}\n`);
  }

  static decode(buffer) {
    const dataStrRaw = buffer.toString();
    const data = JSON.parse(dataStrRaw.replace('\n', ''));
    return data;
  }

  parse(data) {
    const response = {};
    this.log.info('client query :', data);
    switch (data.cmd) {
      case 'connect':
        response.cmd = 'connect';
        response.code = 200;
        response.data = 'ready';
        return response;

      case 'romReadByte':
        return { cmd: 'ready' };

      case 'getOperations':
        if (this.startGame) {
          return this.operationsUpdate();
        }
        this.startGame = true;
        return this.operationsInit();

      case 'memoryReadByte':
        if (this.dead(data.data)) {
          this.startGame = false;
        }
        return { cmd: 'memoryReadByte', status: 'ready' };

      default:
        response.code = '500';
        response.status = 'ready';
        return response;
    }
  }
}
