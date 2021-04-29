import net from 'net';
import ora from 'ora';
import bunyan from 'bunyan';
import autoincr from 'autoincr';
import config from '../config';

export default class Hal {
  constructor() {
    this.romHead = [];
    this.log = bunyan.createLogger({ name: 'hal-server ' });
    this.startGame = false;
    this.frame = autoincr();
  }

  start() {
    const spinnerWaitingServer = ora('waiting server...').start();
    const spinnerWaitingClient = ora('waiting client connection...');
    const spinnerWaitingQuery = ora('waiting client query...');

    const server = net.createServer();

    server.on('connection', (socket) => {
      spinnerWaitingClient.succeed('client is connected');
      spinnerWaitingQuery.start();
      this.socket = socket;
      this.send({ operation: 'ready' });

      socket.on('data', (buffer) => {
        const query = Hal.decode(buffer);
        const response = this.parse(query);
        this.send(response);
        spinnerWaitingQuery.text = `frame ${this.frame.next()} :  client request ${query.cmd}`;
        // spinnerWaitingQuery.start();
      });
    });

    server.on('close', () => {
      spinnerWaitingClient.fail('client is disconnected');
    });

    server.on('error', (err) => {
      this.log.error(err);
    });

    server.on('listening', () => {
      spinnerWaitingServer.succeed('server is started');
      spinnerWaitingClient.start();
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
