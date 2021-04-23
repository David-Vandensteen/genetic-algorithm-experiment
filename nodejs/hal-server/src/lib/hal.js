import net from 'net';
import Operation from './operation';
import Macro from './macro';

const { log, error } = console;

export default class Hal {
  static start() {
    const server = net.createServer(() => {
      // socket.write('Echo server\n');
      // socket.pipe(socket);
    });

    server.on('connection', (socket) => {
      log('client connected');
      socket.on('data', (data) => {
        log('client send :', data.toString());
        // socket.write('Ok data received...\n');
        // socket.pipe(socket);
      });
      /*
      setInterval(() => {
        const response = [
          { operation: 'print', params: ['Hello'] },
          { operation: 'emu.frameadvance' },
        ];
        socket.write(`${JSON.stringify(response)}\n`);
        socket.pipe(socket);
      }, 1);
      */
      const response = new Operation()
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
          quantity: 200,
        }))
        .commit();

      socket.write(`${JSON.stringify(response)}\n`);
      socket.pipe(socket);
    });

    server.on('close', () => {
      log('client disconnected');
    });

    server.on('error', (err) => {
      error(err);
    });

    server.on('listening', () => {
      log('server started');
    });

    server.on('data', (data) => {
      log('client send :', data);
    });

    server.listen(81, '127.0.0.1');

    /*
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
        quantity: 200,
      }))
      .commit();
      */
  }
}
