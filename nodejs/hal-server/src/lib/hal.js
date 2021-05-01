import net from 'net';
import bunyan from 'bunyan';
import Spinnies from 'spinnies';
import autoincr from 'autoincr';
import config from '../config';

export default class Hal {
  constructor() {
    this.romHead = [];
    this.log = bunyan.createLogger({ name: 'hal-server ' });
    this.startGame = false;
    this.frame = autoincr();
    this.spinnies = new Spinnies();
    this.spinnies.add('waiting-server');
  }

  start() {
    const server = net.createServer();

    server.on('connection', (socket) => {
      this.spinnies.succeed('waiting-client');
      this.spinnies.add('mode', { text: 'mode : live' });
      this.spinnies.add('player', { text: 'player is alive' });
      this.spinnies.add('frame');
      this.socket = socket;
      this.send({ operation: 'ready' });

      socket.on('data', (buffer) => {
        this.spinnies.update('frame', { text: `frame : ${this.frame.next()}` });
        const query = Hal.decode(buffer);
        const response = this.parse(query);
        this.send(response);
      });
    });

    server.on('close', () => {
      this.spinnies.fail('waiting-client');
    });

    server.on('error', (err) => {
      this.log.error(err);
    });

    server.on('listening', () => {
      this.spinnies.succeed('waiting-server');
      this.spinnies.add('waiting-client');
    });

    server.listen(config.server.port, config.server.host);
  }

  send(data) {
    this.socket.write(`${JSON.stringify(data)}\n`);
  }

  static decode(buffer) {
    const dataStrRaw = buffer.toString();
    const data = JSON.parse(dataStrRaw.replace('\n', ''));
    return data;
  }

  parse(query) {
    switch (query.cmd) {
      case 'connect':
        return { cmd: 'connect' };

      case 'romReadByte':
        return { cmd: 'ready' };

      case 'getOperations':
        if (this.startGame) {
          return this.operationsUpdate();
        }
        this.startGame = true;
        return this.operationsInit();

      case 'memoryReadByte':
        if (this.dead(query.data)) {
          this.startGame = false;
        }
        return { cmd: 'memoryReadByte', status: 'ready' };

      default:
        return { cmd: 'nothing' };
    }
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
}
